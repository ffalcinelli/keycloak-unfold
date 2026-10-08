const test = require('node:test');
const assert = require('node:assert');
const { JSDOM } = require('jsdom');

const THEME_TOGGLE_PATH =
  require.resolve('../theme/unfold-base/login/resources/js/theme-toggle.js');

/**
 * Set up a fresh JSDOM environment and inject Node globals so that
 * theme-toggle.js can be require()'d (and thus V8-instrumented) while
 * still running against a real DOM.
 *
 * Options:
 *  - readyState: force document.readyState at require() time ('loading' by default in JSDOM)
 *  - storageThrows: make every localStorage access throw, as in some private modes
 */
function setupDOM(storedTheme, prefersDark, { readyState, storageThrows = false } = {}) {
  const dom = new JSDOM(
    `<!DOCTYPE html>
    <html>
    <head></head>
    <body>
        <div id="theme-toggle-sun"></div>
        <div id="theme-toggle-moon"></div>
        <button id="theme-toggle-button"></button>
    </body>
    </html>`,
    { url: 'http://localhost' }
  );

  const { window } = dom;
  const { document } = window;

  if (storedTheme) {
    window.localStorage.setItem('unfold-theme-preference', storedTheme);
  }

  // Point Node globals at the JSDOM window so require()'d code uses them
  global.document = document;
  global.window = window;
  global.localStorage = storageThrows
    ? {
        getItem() {
          throw new Error('SecurityError');
        },
        setItem() {
          throw new Error('SecurityError');
        },
      }
    : window.localStorage;

  // Mock matchMedia, capturing 'change' listeners so tests can simulate OS theme switches
  const changeListeners = [];
  global.matchMedia = window.matchMedia = (query) => ({
    matches: prefersDark && query === '(prefers-color-scheme: dark)',
    addEventListener: (type, listener) => {
      if (type === 'change') changeListeners.push(listener);
    },
  });

  if (readyState) {
    Object.defineProperty(document, 'readyState', { value: readyState, configurable: true });
  }

  // Bust the require cache so each test gets a fresh module execution
  delete require.cache[THEME_TOGGLE_PATH];
  const { applyTheme, onReady } = require(THEME_TOGGLE_PATH);

  const isDark = () => document.documentElement.classList.contains('dark');
  const emitSystemChange = (matches) =>
    changeListeners.forEach((listener) => listener({ matches }));

  return { window, document, applyTheme, onReady, isDark, emitSystemChange, changeListeners };
}

test('explicit dark theme in localStorage applies dark theme', () => {
  const { document } = setupDOM('dark', false);
  assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
  assert.ok(document.documentElement.classList.contains('dark'));
});

test('explicit light theme in localStorage applies light theme', () => {
  const { document } = setupDOM('light', true);
  assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), false);
  assert.strictEqual(document.documentElement.classList.contains('dark'), false);
});

test('no localStorage, system prefers dark applies dark theme', () => {
  const { document } = setupDOM(null, true);
  assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
  assert.ok(document.documentElement.classList.contains('dark'));
});

test('no localStorage, system prefers light applies light theme', () => {
  const { document } = setupDOM(null, false);
  assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), false);
  assert.strictEqual(document.documentElement.classList.contains('dark'), false);
});

test('icon visibility is correctly toggled on initialization (dark mode)', () => {
  const { document } = setupDOM('dark', false);
  const sunIcon = document.getElementById('theme-toggle-sun');
  const moonIcon = document.getElementById('theme-toggle-moon');

  assert.strictEqual(sunIcon.classList.contains('hidden'), false);
  assert.ok(moonIcon.classList.contains('hidden'));
});

test('icon visibility is correctly toggled on initialization (light mode)', () => {
  const { document } = setupDOM('light', false);
  const sunIcon = document.getElementById('theme-toggle-sun');
  const moonIcon = document.getElementById('theme-toggle-moon');

  assert.ok(sunIcon.classList.contains('hidden'));
  assert.strictEqual(moonIcon.classList.contains('hidden'), false);
});

test('applyTheme directly toggles theme classes and icons correctly', () => {
  const { applyTheme, document } = setupDOM('light', false);
  const sunIcon = document.getElementById('theme-toggle-sun');
  const moonIcon = document.getElementById('theme-toggle-moon');

  // Apply dark theme
  applyTheme(true);
  assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
  assert.ok(document.documentElement.classList.contains('dark'));
  assert.strictEqual(sunIcon.classList.contains('hidden'), false);
  assert.ok(moonIcon.classList.contains('hidden'));

  // Apply light theme
  applyTheme(false);
  assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), false);
  assert.strictEqual(document.documentElement.classList.contains('dark'), false);
  assert.ok(sunIcon.classList.contains('hidden'));
  assert.strictEqual(moonIcon.classList.contains('hidden'), false);
});

test('applyTheme works without throwing when icons are missing', () => {
  const { applyTheme, document } = setupDOM('light', false);

  // Remove icons
  document.getElementById('theme-toggle-sun').remove();
  document.getElementById('theme-toggle-moon').remove();

  // Should not throw
  assert.doesNotThrow(() => {
    applyTheme(true);
  });

  assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
  assert.ok(document.documentElement.classList.contains('dark'));
});

test('click listener is attached when the script runs after DOMContentLoaded', () => {
  const { document, isDark, window } = setupDOM('light', false, { readyState: 'complete' });
  const button = document.getElementById('theme-toggle-button');

  button.click();
  assert.ok(isDark());
  assert.strictEqual(window.localStorage.getItem('unfold-theme-preference'), 'dark');

  button.click();
  assert.strictEqual(isDark(), false);
  assert.strictEqual(window.localStorage.getItem('unfold-theme-preference'), 'light');
});

test('click listener is attached on DOMContentLoaded while the document is loading', () => {
  const { document, isDark } = setupDOM('light', false, { readyState: 'loading' });
  const button = document.getElementById('theme-toggle-button');

  button.click();
  assert.strictEqual(isDark(), false, 'no listener before DOMContentLoaded');

  document.dispatchEvent(new document.defaultView.Event('DOMContentLoaded'));
  button.click();
  assert.ok(isDark());
});

test('aria-pressed reflects the current theme', () => {
  const { document } = setupDOM('dark', false, { readyState: 'complete' });
  const button = document.getElementById('theme-toggle-button');

  assert.strictEqual(button.getAttribute('aria-pressed'), 'true');
  button.click();
  assert.strictEqual(button.getAttribute('aria-pressed'), 'false');
});

test('system color scheme changes are followed when no preference is stored', () => {
  const { isDark, emitSystemChange } = setupDOM(null, false, { readyState: 'complete' });

  emitSystemChange(true);
  assert.ok(isDark());
  emitSystemChange(false);
  assert.strictEqual(isDark(), false);
});

test('system color scheme changes are ignored when a preference is stored', () => {
  const { isDark, emitSystemChange } = setupDOM('light', false, { readyState: 'complete' });

  emitSystemChange(true);
  assert.strictEqual(isDark(), false);
});

test('throwing localStorage falls back to the system preference and toggling still works', () => {
  let ctx;
  assert.doesNotThrow(() => {
    ctx = setupDOM(null, true, { readyState: 'complete', storageThrows: true });
  });
  assert.ok(ctx.isDark());

  ctx.document.getElementById('theme-toggle-button').click();
  assert.strictEqual(ctx.isDark(), false);

  // no stored preference can be read, so system changes keep applying
  ctx.emitSystemChange(true);
  assert.ok(ctx.isDark());
});

test('onReady runs the callback immediately once the DOM is parsed', () => {
  const { onReady } = setupDOM(null, false, { readyState: 'interactive' });
  let called = false;
  onReady(() => {
    called = true;
  });
  assert.ok(called);
});

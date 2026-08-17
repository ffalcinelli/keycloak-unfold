const test = require('node:test');
const assert = require('node:assert');
const { JSDOM } = require('jsdom');

const THEME_TOGGLE_PATH = require.resolve(
  '../theme/unfold-base/login/resources/js/theme-toggle.js'
);

/**
 * Set up a fresh JSDOM environment and inject Node globals so that
 * theme-toggle.js can be require()'d (and thus V8-instrumented) while
 * still running against a real DOM.
 */
function setupDOM(storedTheme, prefersDark) {
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

  // Point Node globals at the JSDOM window so require()'d code uses them
  global.document = document;
  global.window = window;
  global.localStorage = window.localStorage;

  // Mock matchMedia
  global.matchMedia = window.matchMedia = (query) => ({
    matches: prefersDark && query === '(prefers-color-scheme: dark)',
    addEventListener: () => {},
  });

  if (storedTheme) {
    window.localStorage.setItem('unfold-theme-preference', storedTheme);
  }

  // Bust the require cache so each test gets a fresh module execution
  delete require.cache[THEME_TOGGLE_PATH];
  const { applyTheme } = require(THEME_TOGGLE_PATH);

  return { window, document, applyTheme };
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

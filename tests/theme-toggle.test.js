const test = require('node:test');
const assert = require('node:assert');
const { JSDOM } = require('jsdom');
const fs = require('fs');
const path = require('path');

const scriptContent = fs.readFileSync(path.join(__dirname, '../theme/unfold-base/login/resources/js/theme-toggle.js'), 'utf-8');

function setupDOM(storedTheme, prefersDark) {
    const dom = new JSDOM(`
        <!DOCTYPE html>
        <html>
        <head></head>
        <body>
            <div id="theme-toggle-sun"></div>
            <div id="theme-toggle-moon"></div>
            <button id="theme-toggle-button"></button>
        </body>
        </html>
    `, {
        url: 'http://localhost',
        runScripts: 'dangerously'
    });

    const window = dom.window;
    const document = window.document;

    // Mock matchMedia
    window.matchMedia = (query) => {
        return {
            matches: prefersDark && query === '(prefers-color-scheme: dark)',
            addEventListener: () => {}
        };
    };

    // Set localStorage
    if (storedTheme) {
        window.localStorage.setItem('unfold-theme-preference', storedTheme);
    }

    // Inject script
    const scriptEl = document.createElement('script');
    scriptEl.textContent = scriptContent;
    document.head.appendChild(scriptEl);

    return { window, document };
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
    const { window, document } = setupDOM('light', false);
    const sunIcon = document.getElementById('theme-toggle-sun');
    const moonIcon = document.getElementById('theme-toggle-moon');

    // Apply dark theme
    window.applyTheme(true);
    assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
    assert.ok(document.documentElement.classList.contains('dark'));
    assert.strictEqual(sunIcon.classList.contains('hidden'), false);
    assert.ok(moonIcon.classList.contains('hidden'));

    // Apply light theme
    window.applyTheme(false);
    assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), false);
    assert.strictEqual(document.documentElement.classList.contains('dark'), false);
    assert.ok(sunIcon.classList.contains('hidden'));
    assert.strictEqual(moonIcon.classList.contains('hidden'), false);
});

test('applyTheme works without throwing when icons are missing', () => {
    const { window, document } = setupDOM('light', false);

    // Remove icons
    document.getElementById('theme-toggle-sun').remove();
    document.getElementById('theme-toggle-moon').remove();

    // Should not throw
    assert.doesNotThrow(() => {
        window.applyTheme(true);
    });

    assert.ok(document.documentElement.classList.contains('pf-v5-theme-dark'));
    assert.ok(document.documentElement.classList.contains('dark'));
});

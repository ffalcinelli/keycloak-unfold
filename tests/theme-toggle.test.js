const { JSDOM } = require('jsdom');
const fs = require('fs');
const path = require('path');
const { test, describe } = require('node:test');
const assert = require('node:assert');

const scriptContent = fs.readFileSync(path.join(__dirname, '../theme/unfold-base/login/resources/js/theme-toggle.js'), 'utf-8');

describe('applyTheme', () => {
    function setupDOM(html = '') {
        const dom = new JSDOM(`
            <!DOCTYPE html>
            <html lang="en">
            <head></head>
            <body>
                ${html}
            </body>
            </html>
        `, {
            url: "http://localhost",
            runScripts: "dangerously"
        });

        const window = dom.window;
        const document = window.document;

        // Mock matchMedia
        window.matchMedia = () => ({
            matches: false,
            addEventListener: () => {}
        });

        // Inject script
        const script = document.createElement('script');
        script.textContent = scriptContent;
        document.body.appendChild(script);

        return { window, document };
    }

    test('should add dark classes and toggle icons when isDark is true', () => {
        const html = `
            <div id="theme-toggle-sun" class="hidden"></div>
            <div id="theme-toggle-moon"></div>
        `;
        const { window, document } = setupDOM(html);

        // Call applyTheme
        window.applyTheme(true);

        // Check classes on document element
        assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), true);
        assert.strictEqual(document.documentElement.classList.contains('dark'), true);

        // Check icons
        assert.strictEqual(document.getElementById('theme-toggle-sun').classList.contains('hidden'), false);
        assert.strictEqual(document.getElementById('theme-toggle-moon').classList.contains('hidden'), true);
    });

    test('should remove dark classes and toggle icons when isDark is false', () => {
        const html = `
            <div id="theme-toggle-sun"></div>
            <div id="theme-toggle-moon" class="hidden"></div>
        `;
        const { window, document } = setupDOM(html);

        // Initial state is dark for the test
        document.documentElement.classList.add('pf-v5-theme-dark', 'dark');

        // Call applyTheme
        window.applyTheme(false);

        // Check classes on document element
        assert.strictEqual(document.documentElement.classList.contains('pf-v5-theme-dark'), false);
        assert.strictEqual(document.documentElement.classList.contains('dark'), false);

        // Check icons
        assert.strictEqual(document.getElementById('theme-toggle-sun').classList.contains('hidden'), true);
        assert.strictEqual(document.getElementById('theme-toggle-moon').classList.contains('hidden'), false);
    });

    test('should not throw if icons are missing', () => {
        const { window, document } = setupDOM();

        assert.doesNotThrow(() => {
            window.applyTheme(true);
        });
        assert.strictEqual(document.documentElement.classList.contains('dark'), true);
    });
});

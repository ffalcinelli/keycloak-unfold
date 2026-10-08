// Regenerates the README preview images in assets/ from a running Keycloak (see docker-compose.yml).
// Usage: npm run screenshots   (honours KEYCLOAK_URL, default http://localhost:8080)
const { chromium } = require('@playwright/test');
const { KEYCLOAK_URL } = require('../tests/keycloak-url');

const VARIANTS = [
  { name: 'unfold-default', realm: 'unfold-default-demo' },
  { name: 'unfold-full', realm: 'unfold-full-demo' },
];

(async () => {
  const browser = await chromium.launch();
  try {
    for (const { name, realm } of VARIANTS) {
      const context = await browser.newContext({
        viewport: { width: 1440, height: 900 },
        colorScheme: 'light',
      });
      const page = await context.newPage();

      await page.goto(`${KEYCLOAK_URL}/realms/${realm}/account/`);
      await page.locator('#kc-form-login').waitFor();
      await page.screenshot({ path: `assets/${name}-login.png` });

      await page.locator('#username').fill('testuser');
      await page.locator('#password').fill('password');
      await page.locator('#kc-login').click();
      await page.locator('.pf-v5-c-page__main').waitFor();
      await page.waitForLoadState('networkidle');
      await page.screenshot({ path: `assets/${name}-account.png` });

      console.log(`✓ assets/${name}-login.png, assets/${name}-account.png`);
      await context.close();
    }
  } finally {
    await browser.close();
  }
})();

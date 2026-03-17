const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 }
  });
  const page = await context.newPage();

  await page.goto('http://localhost:8080/realms/Unfold-Split-Demo/account/');

  // Wait for network idle and specific element to ensure page is loaded
  await page.waitForLoadState('networkidle');
  await page.waitForSelector('#kc-header-wrapper');

  // Take screenshot
  await page.screenshot({ path: 'assets/login-screenshot.png', fullPage: true });

  await browser.close();
})();

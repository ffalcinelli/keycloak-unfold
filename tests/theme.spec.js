const { test, expect } = require('@playwright/test');

test('Keycloak Unfold Theme - Demo Login Page', async ({ page }) => {
  // Go to Demo realm account console, which should redirect to demo realm login page
  // The demo realm is configured to use 'unfold' theme
  await page.goto('http://localhost:8080/realms/demo/account/');

  // Wait for login form to appear
  await page.waitForSelector('#kc-form-login');

  // Verify custom CSS overrides applied to the main container
  const mainContainer = page.locator('.pf-v5-c-login__main');
  const mainStyle = await mainContainer.evaluate(el => window.getComputedStyle(el));

  // Check border-radius (0.5rem = 8px usually)
  expect(mainStyle.borderRadius).toMatch(/8px/);
  // Check background color
  expect(mainStyle.backgroundColor).toMatch(/rgb\(255, 255, 255\)/);

  // Check the primary button
  const loginButton = page.locator('#kc-login');
  const buttonStyle = await loginButton.evaluate(el => window.getComputedStyle(el));

  // Primary button color should be #0f172a (slate-900) -> rgb(15, 23, 42)
  expect(buttonStyle.backgroundColor).toMatch(/rgb\(15, 23, 42\)/);
  // Button border radius (0.375rem = 6px)
  expect(buttonStyle.borderRadius).toMatch(/6px/);

  // Verify body background
  const bodyStyle = await page.evaluate(() => window.getComputedStyle(document.body));
  // Background should be #f8fafc (slate-50) -> rgb(248, 250, 252)
  expect(bodyStyle.backgroundColor).toMatch(/rgb\(248, 250, 252\)/);
});

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
  // Check background color (white)
  expect(mainStyle.backgroundColor).toMatch(/rgb\(255, 255, 255\)/);

  // Check the primary button
  const loginButton = page.locator('#kc-login');
  const buttonStyle = await loginButton.evaluate(el => window.getComputedStyle(el));

  // Primary button color should be primary-600 -> rgb(152, 16, 250) or oklch
  expect(buttonStyle.backgroundColor).toMatch(/(oklch\(0\.558 0\.288 302\.321\)|rgb\(152, 16, 250\))/);
  // Button border radius (0.375rem = 6px)
  expect(buttonStyle.borderRadius).toMatch(/6px/);

  // Verify body background
  const bodyStyle = await page.evaluate(() => window.getComputedStyle(document.body));
  // Background should be base-50 -> rgb(249, 250, 251) or oklch
  expect(bodyStyle.backgroundColor).toMatch(/(oklch\(0\.985 0\.002 247\.839\)|rgb\(249, 250, 251\))/);
});

test('Keycloak Unfold Theme - Demo Account Console', async ({ page }) => {
  // Go to Demo realm account console
  await page.goto('http://localhost:8080/realms/demo/account/');

  // Login
  await page.waitForSelector('#kc-form-login');
  await page.fill('#username', 'testuser');
  await page.fill('#password', 'password');
  await page.click('#kc-login');

  // Wait for Account Console to load
  await page.waitForSelector('.pf-v5-c-page__main');

  // Verify body background and font-family
  const bodyStyle = await page.evaluate(() => window.getComputedStyle(document.body));
  expect(bodyStyle.backgroundColor).toMatch(/(oklch\(0\.985 0\.002 247\.839\)|rgb\(249, 250, 251\))/);
  expect(bodyStyle.fontFamily).toMatch(/Inter/);

  // Verify main container background
  const mainContainer = page.locator('.pf-v5-c-page__main');
  const mainStyle = await mainContainer.evaluate(el => window.getComputedStyle(el));
  expect(mainStyle.backgroundColor).toMatch(/(oklch\(0\.985 0\.002 247\.839\)|rgb\(249, 250, 251\))/);

  // Verify form-control background color
  const formControl = page.locator('.pf-v5-c-form-control').first();
  const formControlStyle = await formControl.evaluate(el => window.getComputedStyle(el));
  // Form control background color should be base-200 -> #fff
  expect(formControlStyle.backgroundColor).toMatch(/rgb\(255, 255, 255\)/);

  // Verify primary button background
  const primaryButton = page.locator('.pf-v5-c-button.pf-m-primary').first();
  const buttonStyle = await primaryButton.evaluate(el => window.getComputedStyle(el));
  expect(buttonStyle.backgroundColor).toMatch(/(oklch\(0\.558 0\.288 302\.321\)|rgb\(152, 16, 250\))/);
});

const { test, expect } = require('@playwright/test');

const DEFAULT_REALM = '/realms/demo/account/';
const FULL_REALM = '/realms/unfold-full-demo/account/';

/**
 * Resolve a CSS color expression (e.g. `var(--color-primary-600)`) in the page context,
 * so assertions compare against the theme's own tokens instead of hardcoded rgb/oklch values.
 */
function resolveColor(page, cssColor) {
  return page.evaluate((value) => {
    const probe = document.createElement('div');
    probe.style.color = value;
    document.body.appendChild(probe);
    const resolved = getComputedStyle(probe).color;
    probe.remove();
    return resolved;
  }, cssColor);
}

function computed(locator, property) {
  return locator.evaluate((el, prop) => getComputedStyle(el)[prop], property);
}

async function login(page, realmPath, username = 'testuser') {
  await page.goto(realmPath);
  await page.locator('#username').fill(username);
  await page.locator('#password').fill('password');
  await page.locator('#kc-login').click();
}

test.describe('unfold-default (demo realm)', () => {
  test.beforeEach(async ({ page }) => {
    await page.emulateMedia({ colorScheme: 'light' });
  });

  test('login page uses the Unfold design tokens', async ({ page }) => {
    await page.goto(DEFAULT_REALM);
    await expect(page.locator('#kc-form-login')).toBeVisible();

    const card = page.locator('.pf-v5-c-login__main');
    expect(await computed(card, 'borderRadius')).toBe('12px');
    expect(await computed(card, 'backgroundColor')).toBe('rgb(255, 255, 255)');

    const loginButton = page.locator('#kc-login');
    expect(await computed(loginButton, 'backgroundColor')).toBe(
      await resolveColor(page, 'var(--color-primary-600)')
    );
    expect(await computed(loginButton, 'borderRadius')).toBe('6px');

    expect(await computed(page.locator('body'), 'backgroundColor')).toBe(
      await resolveColor(page, 'var(--color-base-50)')
    );
  });

  test('account console is themed', async ({ page }) => {
    await login(page, DEFAULT_REALM);
    await expect(page.locator('.pf-v5-c-page__main')).toBeVisible();

    expect(await computed(page.locator('body'), 'fontFamily')).toMatch(/(Inter|RedHatText)/);

    const primaryButton = page.locator('.pf-v5-c-button.pf-m-primary').first();
    await expect(primaryButton).toBeVisible();
    expect(await computed(primaryButton, 'backgroundColor')).toBe(
      await resolveColor(page, 'var(--color-primary-600)')
    );
  });

  test('registration page', async ({ page }) => {
    await page.goto(DEFAULT_REALM);
    await page.locator('#kc-registration a').click();
    await expect(page.locator('#kc-register-form')).toBeVisible();

    for (const id of ['#firstName', '#lastName', '#email', '#password', '#password-confirm']) {
      await expect(page.locator(id)).toBeVisible();
    }

    expect(await computed(page.locator('.pf-v5-c-login__main'), 'borderRadius')).toBe('12px');
    const registerButton = page.locator('#kc-register-form button[type="submit"]');
    expect(await computed(registerButton, 'backgroundColor')).toBe(
      await resolveColor(page, 'var(--color-primary-600)')
    );
  });

  test('reset password page', async ({ page }) => {
    await page.goto(DEFAULT_REALM);
    await page.getByRole('link', { name: 'Forgot Password?' }).click();
    await expect(page.locator('#kc-reset-password-form')).toBeVisible();
    await expect(page.locator('#username')).toBeVisible();
  });

  test('dark mode toggle switches theme, icons and persists the choice', async ({ page }) => {
    await page.goto(DEFAULT_REALM);

    const html = page.locator('html');
    const toggleButton = page.locator('#theme-toggle-button');
    const sunIcon = page.locator('#theme-toggle-sun');
    const moonIcon = page.locator('#theme-toggle-moon');

    await expect(html).not.toHaveClass(/\bdark\b/);
    await expect(toggleButton).toHaveAttribute('aria-pressed', 'false');

    await toggleButton.click();
    await expect(html).toHaveClass(/\bdark\b/);
    await expect(html).toHaveClass(/\bpf-v5-theme-dark\b/);
    await expect(toggleButton).toHaveAttribute('aria-pressed', 'true');
    await expect(sunIcon).toBeVisible();
    await expect(moonIcon).toBeHidden();
    expect(await page.evaluate(() => localStorage.getItem('unfold-theme-preference'))).toBe('dark');

    // the stored preference survives a reload and wins over the (light) system setting
    await page.reload();
    await expect(html).toHaveClass(/\bdark\b/);

    await toggleButton.click();
    await expect(html).not.toHaveClass(/\bdark\b/);
    await expect(sunIcon).toBeHidden();
    await expect(moonIcon).toBeVisible();
    expect(await page.evaluate(() => localStorage.getItem('unfold-theme-preference'))).toBe(
      'light'
    );
  });

  test('system dark preference is applied without a stored choice', async ({ page }) => {
    await page.emulateMedia({ colorScheme: 'dark' });
    await page.goto(DEFAULT_REALM);
    await expect(page.locator('html')).toHaveClass(/\bdark\b/);
  });

  test('brand logo follows the theme', async ({ page }) => {
    await page.goto(DEFAULT_REALM);

    const logoLight = page.locator('#kc-logo-light');
    const logoDark = page.locator('#kc-logo-dark');
    await expect(logoLight).toBeVisible();
    await expect(logoDark).toBeHidden();

    await page.locator('#theme-toggle-button').click();
    await expect(logoLight).toBeHidden();
    await expect(logoDark).toBeVisible();
  });

  test('upstream pages not overridden by the theme still render (OTP setup)', async ({ page }) => {
    await login(page, DEFAULT_REALM, 'otpuser');
    await expect(page.locator('#kc-totp-settings-form')).toBeVisible();
    await expect(page.locator('#kc-header')).toBeVisible();
  });
});

test.describe('unfold-full (unfold-full-demo realm)', () => {
  test.use({ viewport: { width: 1440, height: 900 } });

  test('split layout with hero image', async ({ page }) => {
    await page.goto(FULL_REALM);
    await expect(page.locator('#kc-form-login')).toBeVisible();

    const hero = page.locator('#kc-hero');
    await expect(hero).toBeVisible();
    expect(await computed(hero, 'backgroundImage')).toContain('login-bg.jpg');
    await expect(hero.locator('blockquote')).not.toBeEmpty();

    // the back-link is opt-in through kcLogoLink
    await expect(page.locator('#kc-back-link')).toHaveCount(0);
  });

  test('hero is hidden on small screens', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.goto(FULL_REALM);
    await expect(page.locator('#kc-form-login')).toBeVisible();
    await expect(page.locator('#kc-hero')).toBeHidden();
  });

  test('locale switcher translates core and theme strings', async ({ page }) => {
    await page.goto(FULL_REALM);
    const select = page.locator('#login-select-toggle');
    await expect(select).toBeVisible();

    const italian = await select.locator('option', { hasText: 'Italiano' }).getAttribute('value');
    await select.selectOption(italian);

    await expect(page.locator('html')).toHaveAttribute('lang', 'it');
    await expect(page.locator('#kc-login')).toHaveText('Accedi');
    await expect(page.locator('#theme-toggle-button')).toHaveAttribute(
      'aria-label',
      'Attiva/disattiva tema scuro'
    );
  });
});

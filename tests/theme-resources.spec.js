const { test, expect } = require('@playwright/test');

for (const realm of ['demo', 'unfold-full-demo']) {
  test(`all login page resources load (${realm})`, async ({ page }) => {
    const failedResources = [];

    // 404/500 means a missing or broken theme resource (CSS, JS, images, fonts)
    page.on('response', (response) => {
      if ([404, 500].includes(response.status())) {
        failedResources.push({ url: response.url(), status: response.status() });
      }
    });

    await page.goto(`/realms/${realm}/account/`, { waitUntil: 'load' });
    await expect(page.locator('#kc-form-login')).toBeVisible();

    expect(failedResources).toEqual([]);
  });
}

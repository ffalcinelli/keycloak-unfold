const { test, expect } = require('@playwright/test');

test('Keycloak Unfold - Verify all resources are available', async ({ page }) => {
  const failedResources = [];

  page.on('response', (response) => {
    const status = response.status();
    // 401 Unauthorized is often expected for auth endpoints, but 404/500 indicates a missing or broken resource
    if (status >= 400 && status !== 401) {
      // Exclude keycloak API endpoints that might legitimately return 4xx in some cases like 409 or 400
      // Focus mainly on missing static resources (CSS, JS, images, fonts)
      if (status === 404 || status === 500) {
        failedResources.push({ url: response.url(), status });
      }
    }
  });

  // Navigate to login page
  await page.goto('http://localhost:8080/realms/demo/account/', { waitUntil: 'domcontentloaded' });

  // Filter out authChecker.js as per user's prompt (it might be missing locally but present in production)
  const actualFailedResources = failedResources.filter(
    (res) => !res.url.includes('authChecker.js')
  );

  if (actualFailedResources.length > 0) {
    console.error('Failed resources found:', actualFailedResources);
  }

  expect(actualFailedResources.length).toBe(0);
});

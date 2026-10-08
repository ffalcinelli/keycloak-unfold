const { defineConfig, devices } = require('@playwright/test');
const { KEYCLOAK_URL } = require('./tests/keycloak-url');

module.exports = defineConfig({
  testDir: './tests',
  testMatch: '**/*.spec.js',
  globalSetup: './tests/global-setup.js',
  globalTeardown: './tests/global-teardown.js',
  fullyParallel: true,
  retries: 0,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: KEYCLOAK_URL,
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});

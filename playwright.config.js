const { defineConfig, devices } = require('@playwright/test');

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
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});

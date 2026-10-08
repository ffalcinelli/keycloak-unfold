const globals = require('globals');
const playwright = require('eslint-plugin-playwright');
const prettier = require('eslint-config-prettier');

module.exports = [
  {
    ignores: ['coverage/**', 'playwright-report/**', 'test-results/**'],
  },
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'commonjs',
      globals: {
        ...globals.node,
      },
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
    },
  },
  {
    // Browser scripts: theme resources and the landing page
    files: ['theme/**/*.js', 'docs/**/*.js'],
    languageOptions: {
      sourceType: 'script',
      globals: {
        ...globals.browser,
        module: 'readonly',
      },
    },
  },
  {
    files: ['tests/**/*.spec.js'],
    plugins: {
      playwright: playwright,
    },
    rules: {
      ...playwright.configs['recommended'].rules,
    },
  },
  // Must stay last: turns off stylistic rules that conflict with Prettier
  prettier,
];

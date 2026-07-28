const playwright = require('eslint-plugin-playwright');

module.exports = [
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'commonjs',
      globals: {
        browser: 'readonly',
        window: 'readonly',
        document: 'readonly',
        localStorage: 'readonly',
        expect: 'readonly',
        require: 'readonly',
        process: 'readonly',
        __dirname: 'readonly',
        module: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
    },
  },
  {
    files: ['tests/**/*.spec.js', 'tests/**/*.test.js'],
    plugins: {
      playwright: playwright,
    },
    rules: {
      ...playwright.configs['recommended'].rules,
    },
  },
];

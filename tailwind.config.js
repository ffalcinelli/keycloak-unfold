/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./theme/unfold/**/*.ftl"],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        base: {
          50: 'var(--color-base-50)',
          100: 'var(--color-base-100)',
          200: 'var(--color-base-200)',
          300: 'var(--color-base-300)',
          400: 'var(--color-base-400)',
          500: 'var(--color-base-500)',
          600: 'var(--color-base-600)',
          700: 'var(--color-base-700)',
          800: 'var(--color-base-800)',
          900: 'var(--color-base-900)',
          950: 'var(--color-base-950)',
        },
        primary: {
          50: 'var(--color-primary-50)',
          100: 'var(--color-primary-100)',
          200: 'var(--color-primary-200)',
          300: 'var(--color-primary-300)',
          400: 'var(--color-primary-400)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          700: 'var(--color-primary-700)',
          800: 'var(--color-primary-800)',
          900: 'var(--color-primary-900)',
          950: 'var(--color-primary-950)',
        },
        font: {
          subtle: {
            light: 'var(--color-base-500)',
            dark: 'var(--color-base-400)',
          },
          default: {
            light: 'var(--color-base-600)',
            dark: 'var(--color-base-300)',
          },
          important: {
            light: 'var(--color-base-900)',
            dark: 'var(--color-base-100)',
          }
        }
      },
      borderRadius: {
        'default': '0.375rem',
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

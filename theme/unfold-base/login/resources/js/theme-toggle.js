const DARK_MODE_CLASS = 'pf-v5-theme-dark';
const THEME_STORAGE_KEY = 'unfold-theme-preference';
const COLOR_SCHEME_QUERY = '(prefers-color-scheme: dark)';

// localStorage can throw (e.g. blocked site data, some private modes); never let that break theming
function readPreference() {
  try {
    return localStorage.getItem(THEME_STORAGE_KEY);
  } catch {
    return null;
  }
}

function writePreference(value) {
  try {
    localStorage.setItem(THEME_STORAGE_KEY, value);
  } catch {
    // preference simply won't persist
  }
}

function applyTheme(isDark) {
  const { classList } = document.documentElement;
  classList.toggle(DARK_MODE_CLASS, isDark);
  classList.toggle('dark', isDark);

  const sunIcon = document.getElementById('theme-toggle-sun');
  const moonIcon = document.getElementById('theme-toggle-moon');

  if (sunIcon && moonIcon) {
    sunIcon.classList.toggle('hidden', !isDark);
    moonIcon.classList.toggle('hidden', isDark);
  }

  const toggleButton = document.getElementById('theme-toggle-button');
  if (toggleButton) {
    toggleButton.setAttribute('aria-pressed', String(isDark));
  }
}

function initializeTheme() {
  const storedTheme = readPreference();

  let isDark;
  if (storedTheme === 'dark') {
    isDark = true;
  } else if (storedTheme === 'light') {
    isDark = false;
  } else {
    isDark = window.matchMedia(COLOR_SCHEME_QUERY).matches;
  }

  applyTheme(isDark);
  return isDark;
}

// Run once the DOM is parsed, even if this script executes after DOMContentLoaded already fired
function onReady(fn) {
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', fn);
  } else {
    fn();
  }
}

// Immediately invoke to prevent FOUC
let currentIsDark = initializeTheme();

onReady(() => {
  // Re-apply to make sure icons are toggled correctly if they were rendered after script execution
  applyTheme(currentIsDark);

  const toggleButton = document.getElementById('theme-toggle-button');
  if (toggleButton) {
    toggleButton.addEventListener('click', () => {
      currentIsDark = !currentIsDark;
      writePreference(currentIsDark ? 'dark' : 'light');
      applyTheme(currentIsDark);
    });
  }

  // Follow system changes only while no explicit preference is stored
  window.matchMedia(COLOR_SCHEME_QUERY).addEventListener('change', (e) => {
    if (!readPreference()) {
      currentIsDark = e.matches;
      applyTheme(currentIsDark);
    }
  });
});

// Export for Node.js testing environments (no-op in browsers where `module` is undefined)
if (typeof module !== 'undefined') {
  module.exports = { applyTheme, initializeTheme, onReady };
}

const DARK_MODE_CLASS = 'pf-v5-theme-dark';
const THEME_STORAGE_KEY = 'unfold-theme-preference';

function applyTheme(isDark) {
    const { classList } = document.documentElement;
    if (isDark) {
        classList.add(DARK_MODE_CLASS, 'dark');
    } else {
        classList.remove(DARK_MODE_CLASS, 'dark');
    }

    const sunIcon = document.getElementById('theme-toggle-sun');
    const moonIcon = document.getElementById('theme-toggle-moon');

    if (sunIcon && moonIcon) {
        if (isDark) {
            sunIcon.classList.remove('hidden');
            moonIcon.classList.add('hidden');
        } else {
            sunIcon.classList.add('hidden');
            moonIcon.classList.remove('hidden');
        }
    }
}

function initializeTheme() {
    const storedTheme = localStorage.getItem(THEME_STORAGE_KEY);
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

    let isDark = false;
    if (storedTheme === 'dark') {
        isDark = true;
    } else if (storedTheme === 'light') {
        isDark = false;
    } else {
        isDark = prefersDark;
    }

    applyTheme(isDark);
    return isDark;
}

// Immediately invoke to prevent FOUC
let currentIsDark = initializeTheme();

// Wait for DOM to attach event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Re-apply to make sure icons are toggled correctly if they were rendered after script execution
    applyTheme(currentIsDark);

    const toggleButton = document.getElementById('theme-toggle-button');
    if (toggleButton) {
        toggleButton.addEventListener('click', () => {
            currentIsDark = !currentIsDark;
            localStorage.setItem(THEME_STORAGE_KEY, currentIsDark ? 'dark' : 'light');
            applyTheme(currentIsDark);
        });
    }

    // Listen to system changes if no preference is explicitly set
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
        if (!localStorage.getItem(THEME_STORAGE_KEY)) {
            currentIsDark = e.matches;
            applyTheme(currentIsDark);
        }
    });
});

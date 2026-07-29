document.addEventListener('DOMContentLoaded', () => {
  // --- 1. Light/Dark Theme Toggle ---
  const themeToggleBtn = document.getElementById('theme-toggle-btn');
  const body = document.body;

  // Retrieve saved theme or default to dark
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    body.className = savedTheme;
  } else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
    body.className = 'light-theme';
  } else {
    body.className = 'dark-theme';
  }

  themeToggleBtn.addEventListener('click', () => {
    if (body.classList.contains('dark-theme')) {
      body.classList.replace('dark-theme', 'light-theme');
      localStorage.setItem('theme', 'light-theme');
    } else {
      body.classList.replace('light-theme', 'dark-theme');
      localStorage.setItem('theme', 'dark-theme');
    }
  });

  // --- 2. Interactive Mockup Showcase ---
  const showcaseImg = document.getElementById('showcase-img');
  const mockAddress = document.getElementById('mock-address');
  const variantBtns = document.querySelectorAll('[data-variant]');
  const viewBtns = document.querySelectorAll('[data-view]');

  let activeVariant = 'default'; // 'default' or 'full'
  let activeView = 'login'; // 'login' or 'account'

  // Image assets mapping
  const imageMap = {
    'default-login': 'img/unfold-default-login.png',
    'default-account': 'img/unfold-default-account.png',
    'full-login': 'img/unfold-full-login.png',
    'full-account': 'img/unfold-full-account.png',
  };

  // Mock URL address bar mapping
  const urlMap = {
    'default-login': 'http://localhost:8080/realms/unfold-default-demo/login',
    'default-account': 'http://localhost:8080/realms/unfold-default-demo/account/',
    'full-login': 'http://localhost:8080/realms/unfold-full-demo/login',
    'full-account': 'http://localhost:8080/realms/unfold-full-demo/account/',
  };

  function updateShowcase() {
    const key = `${activeVariant}-${activeView}`;

    // Add simple fade effect transition
    showcaseImg.style.opacity = 0;

    setTimeout(() => {
      showcaseImg.src = imageMap[key];
      showcaseImg.alt = `Keycloak Unfold Theme - Variant: ${activeVariant}, View: ${activeView}`;
      mockAddress.textContent = urlMap[key];
      showcaseImg.style.opacity = 1;
    }, 150);
  }

  // Variant selector buttons
  variantBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      variantBtns.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      activeVariant = btn.getAttribute('data-variant');
      updateShowcase();
    });
  });

  // View selector buttons
  viewBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      viewBtns.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      activeView = btn.getAttribute('data-view');
      updateShowcase();
    });
  });

  // --- 3. Interactive Code Terminal ---
  const terminalTabs = document.querySelectorAll('.terminal-tab');
  const terminalContents = document.querySelectorAll('.terminal-content');

  terminalTabs.forEach((tab) => {
    tab.addEventListener('click', () => {
      terminalTabs.forEach((t) => t.classList.remove('active'));
      terminalContents.forEach((c) => c.classList.remove('active'));

      tab.classList.add('active');
      const targetId = `tab-${tab.getAttribute('data-tab')}`;
      document.getElementById(targetId).classList.add('active');
    });
  });

  // --- 4. Copy-to-Clipboard ---
  const copyButtons = document.querySelectorAll('.copy-btn');

  copyButtons.forEach((button) => {
    button.addEventListener('click', () => {
      // Find the associated code text within the same container wrapper
      const wrapper = button.closest('.code-block-wrapper');
      const codeElement = wrapper.querySelector('code');
      const textToCopy = codeElement.textContent;

      navigator.clipboard
        .writeText(textToCopy)
        .then(() => {
          // Change tooltip to "Copied!" and add visual feedback class
          const tooltip = button.querySelector('.tooltip-text');
          tooltip.textContent = 'Copied!';
          button.classList.add('copied');

          // Reset tooltip text and styles after 2 seconds
          setTimeout(() => {
            button.classList.remove('copied');
            tooltip.textContent = 'Copy';
          }, 2000);
        })
        .catch((err) => {
          console.error('Failed to copy text: ', err);
        });
    });
  });
});

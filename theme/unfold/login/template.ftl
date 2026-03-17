<#import "field.ftl" as field>
<#import "footer.ftl" as loginFooter>
<#macro username>
  <#assign label>
    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
  </#assign>
  <@field.group name="username" label=label>
    <div class="${properties.kcInputGroup!}">
      <div class="${properties.kcInputGroupItemClass!} ${properties.kcFill!}">
        <span class="${properties.kcInputClass!} ${properties.kcFormReadOnlyClass!}">
          <input id="kc-attempted-username" value="${auth.attemptedUsername}" readonly>
        </span>
      </div>
      <div class="${properties.kcInputGroupItemClass!}">
        <button id="reset-login" class="${properties.kcFormPasswordVisibilityButtonClass!} kc-login-tooltip" type="button"
              aria-label="${msg('restartLoginTooltip')}" onclick="location.href='${url.loginRestartFlowUrl}'">
            <i class="fa-sync-alt fas" aria-hidden="true"></i>
            <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
        </button>
      </div>
    </@field.group>
</#macro>

<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${properties.kcHtmlLang!"en"}"<#if realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="light${properties.darkMode?has_content?then(' dark', '')}">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>
    <#if properties.darkMode?has_content>
      <script type="module" async blocking="render">
          const DARK_MODE_CLASS = "${properties.kcDarkModeClass!'pf-v5-theme-dark'}";
          const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
          const THEME_STORAGE_KEY = "unfold-theme-preference";

          // Icons for different themes
          const THEME_ICONS = {
              'light': 'fa-sun',
              'dark': 'fa-moon',
              'auto': 'fa-desktop'
          };

          function getStoredTheme() {
              return localStorage.getItem(THEME_STORAGE_KEY) || 'auto';
          }

          function applyTheme(theme) {
              const { classList } = document.documentElement;
              const isDark = theme === 'dark' || (theme === 'auto' && mediaQuery.matches);

              if (isDark) {
                  classList.add(DARK_MODE_CLASS, "dark");
              } else {
                  classList.remove(DARK_MODE_CLASS, "dark");
              }

              // Update the active state in dropdown
              document.querySelectorAll('.theme-btn').forEach(btn => {
                  const val = btn.getAttribute('data-theme-value');
                  if (val === theme) {
                      btn.classList.add('text-primary-600', 'dark:text-primary-500', 'dark:hover:text-primary-500!', 'hover:text-primary-600!');
                  } else {
                      btn.classList.remove('text-primary-600', 'dark:text-primary-500', 'dark:hover:text-primary-500!', 'hover:text-primary-600!');
                  }
              });

              // Update the button icon
              const iconEl = document.getElementById('theme-switcher-icon');
              if (iconEl) {
                  iconEl.className = 'fas ' + THEME_ICONS[theme];
              }
          }

          // Initial setup
          let currentTheme = getStoredTheme();
          applyTheme(currentTheme);

          // Handle system theme changes
          mediaQuery.addEventListener("change", () => {
              if (getStoredTheme() === 'auto') {
                  applyTheme('auto');
              }
          });

          // Setup UI events once DOM is loaded
          window.addEventListener('DOMContentLoaded', () => {
              // We need to re-apply the active state on load to be sure buttons have correct classes
              applyTheme(getStoredTheme());

              const themeButton = document.getElementById('theme-switcher-button');
              const themeDropdown = document.getElementById('theme-switcher-dropdown');

              if (themeButton && themeDropdown) {
                  themeButton.addEventListener('click', (e) => {
                      e.stopPropagation();
                      themeDropdown.classList.toggle('hidden');
                  });

                  // Close dropdown when clicking outside
                  document.addEventListener('click', (e) => {
                      if (!themeDropdown.contains(e.target) && !themeButton.contains(e.target)) {
                          themeDropdown.classList.add('hidden');
                      }
                  });

                  // Setup click handlers for theme buttons
                  document.querySelectorAll('.theme-btn').forEach(btn => {
                      btn.addEventListener('click', () => {
                          const newTheme = btn.getAttribute('data-theme-value');
                          localStorage.setItem(THEME_STORAGE_KEY, newTheme);
                          currentTheme = newTheme;
                          applyTheme(newTheme);
                          themeDropdown.classList.add('hidden');
                      });
                  });
              }
          });
      </script>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    <script type="module">
        import { startSessionPolling } from "${url.resourcesPath}/js/authChecker.js";

        startSessionPolling(
            "${url.ssoLoginInOtherTabsUrl?no_esc}"
        );
    </script>
    <#if authenticationSession?? && authenticationSession.authSessionIdHash??>
        <script type="module">
            import { checkAuthSession } from "${url.resourcesPath}/js/authChecker.js";

            checkAuthSession(
                "${authenticationSession.authSessionIdHash}"
            );
        </script>
    </#if>
    <script>
      // Workaround for https://bugzilla.mozilla.org/show_bug.cgi?id=1404468
      const isFirefox = true;
    </script>
</head>

<body id="keycloak-bg" class="antialiased bg-base-50 font-sans text-font-default-light text-sm dark:bg-base-900 dark:text-font-default-dark bg-base-50 login dark:bg-base-900 ${properties.kcBodyClass!}">

<div id="page" class="min-h-screen flex flex-col justify-center items-center py-12 sm:px-6 lg:px-8 w-full ${properties.kcLogin!}">
    <!-- Centered Form -->
    <div class="w-full sm:max-w-md ${properties.kcLoginContainer!}">
        <div class="bg-white dark:bg-base-800 py-8 px-4 shadow-lg sm:rounded-xl sm:px-10 ${properties.kcLoginMain!} relative">
            <div class="absolute right-4 top-4 sm:right-8 sm:top-8 z-50">
                <div class="relative" id="theme-switcher-container">
                    <button class="block cursor-pointer h-[18px] leading-none text-base-500 hover:text-base-700 dark:hover:text-base-200" id="theme-switcher-button" type="button" aria-label="Theme">
                        <i class="fas fa-desktop" id="theme-switcher-icon"></i>
                    </button>

                    <nav id="theme-switcher-dropdown" class="hidden absolute bg-white border border-base-200 flex flex-col leading-none py-1 -right-2 rounded-default shadow-lg top-7 w-40 z-50 dark:bg-base-800 dark:border-base-700 text-left">
                        <button class="theme-btn cursor-pointer flex flex-row mx-1 px-3 py-1.5 rounded-default hover:bg-base-100 hover:text-base-700 dark:hover:bg-base-700 dark:hover:text-base-200" data-theme-value="light" type="button">
                            <i class="fas fa-sun mr-2 self-center w-4 text-center"></i>
                            <span class="leading-none self-center">Light</span>
                        </button>

                        <button class="theme-btn cursor-pointer flex flex-row leading-none mx-1 px-3 py-1.5 rounded-default hover:bg-base-100 hover:text-base-700 dark:hover:bg-base-700 dark:hover:text-base-200" data-theme-value="dark" type="button">
                            <i class="fas fa-moon mr-2 self-center w-4 text-center"></i>
                            <span class="leading-none self-center">Dark</span>
                        </button>

                        <button class="theme-btn cursor-pointer flex flex-row mx-1 px-3 py-1.5 rounded-default hover:bg-base-100 hover:text-base-700 dark:hover:bg-base-700 dark:hover:text-base-200" data-theme-value="auto" type="button">
                            <i class="fas fa-desktop mr-2 self-center w-4 text-center"></i>
                            <span class="leading-none self-center">System</span>
                        </button>
                    </nav>
                </div>
            </div>
            <header id="kc-header" class="border-b border-base-200 mb-8 pb-6 dark:border-base-800">
                <h1 class="font-semibold text-center">
                    <span class="text-font-important-light dark:text-font-important-dark text-base">Welcome back to</span>
                    <span id="kc-header-wrapper" class="font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mt-1">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</span>
                </h1>
            </header>

            <main>
                <div class="${properties.kcLoginMainHeader!}">
                    <h2 class="block font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mb-4 text-left" id="kc-page-title"><#nested "header"></h2>
                </div>

                <div class="${properties.kcLoginMainBody!}">
                    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                        <div class="mb-4 ${properties.kcAlertClass!} pf-m-${(message.type = 'error')?then('danger', message.type)}">
                            <span class="${properties.kcAlertIconClass!}">
                                <i class="fas <#if message.type = 'success'>fa-check-circle<#elseif message.type = 'warning'>fa-exclamation-triangle<#elseif message.type = 'error'>fa-exclamation-circle<#else>fa-info-circle</#if>"></i>
                            </span>
                            <span class="${properties.kcAlertTitleClass!} kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                        </div>
                    </#if>

                    <#nested "form">
                    <#if displayInfo>
                        <#nested "socialProviders">
                    </#if>

                    <#if auth?has_content && auth.showTryAnotherWayLink()>
                        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" class="mt-4">
                            <div class="${properties.kcFormGroupClass!}">
                                <input type="hidden" name="tryAnotherWay" value="on"/>
                                <a href="#" id="try-another-way"
                                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;"
                                   class="text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("doTryAnotherWay")}</a>
                            </div>
                        </form>
                    </#if>
                </div>

                <#if displayInfo>
                    <div class="mt-6 text-sm text-base-600 dark:text-base-400 ${properties.kcLoginMainFooter!}">
                        <#nested "info">
                    </div>
                </#if>
            </main>
        </div>
    </div>
</div>

</body>
</html>
</#macro>

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
<html class="${properties.kcHtmlClass!}" lang="${lang}"<#if realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="light${darkMode?then(' dark', '')}">
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
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>
    <#if darkMode>
      <script type="module" async blocking="render">
          const DARK_MODE_CLASS = "${properties.kcDarkModeClass!'pf-v5-theme-dark'}";
          const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

          updateDarkMode(mediaQuery.matches);
          mediaQuery.addEventListener("change", (event) => updateDarkMode(event.matches));

          function updateDarkMode(isEnabled) {
            const { classList } = document.documentElement;

            if (isEnabled) {
              classList.add(DARK_MODE_CLASS);
              classList.add("dark");
            } else {
              classList.remove(DARK_MODE_CLASS);
              classList.remove("dark");
            }
          }
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
    <#if authenticationSession??>
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

<div id="page" class="bg-white flex min-h-screen dark:bg-base-900 w-full ${properties.kcLogin!}">
    <!-- Left side (Form) -->
    <div class="flex grow items-center justify-center mx-auto px-4 relative ${properties.kcLoginContainer!}">
        <div class="w-full sm:w-96 ${properties.kcLoginMain!}">
            <header id="kc-header" class="border-b border-base-200 mb-8 pb-6 dark:border-base-800">
                <h1 class="font-semibold text-center">
                    <span class="text-font-important-light dark:text-font-important-dark text-base">Welcome back to</span>
                    <span id="kc-header-wrapper" class="font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mt-1">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</span>
                </h1>
            </header>

            <main>
                <div class="${properties.kcLoginMainHeader!}">
                    <h2 class="block font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mb-4" id="kc-page-title"><#nested "header"></h2>
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

    <!-- Right side (Background Image) -->
    <div class="bg-base-100 flex grow hidden items-center justify-center max-w-3xl xl:max-w-4xl xl:flex dark:bg-base-800 bg-cover bg-center bg-no-repeat" style="background-image: url('${url.resourcesPath}/img/login-bg.jpg');">
    </div>
</div>

</body>
</html>
</#macro>

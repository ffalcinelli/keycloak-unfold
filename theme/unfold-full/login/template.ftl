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
          <input id="kc-attempted-username" value="${kcSanitize(auth.attemptedUsername!'')}" readonly>
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
        <script src="${url.resourcesPath}/js/theme-toggle.js" async blocking="render"></script>
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

<body id="keycloak-bg" class="m-0 p-0 antialiased bg-base-50 font-sans text-font-default-light text-sm dark:bg-base-900 dark:text-font-default-dark login ${properties.kcBodyClass!}">

<div id="page" class="min-h-screen grid grid-cols-1 lg:grid-cols-2 w-full">
    <div class="flex flex-col justify-center items-center w-full bg-base-50 dark:bg-base-900 px-4 sm:px-6 lg:px-12 py-12 relative">
        <a href="${properties.kcLogoLink!'#'}" class="absolute top-6 left-6 z-50 flex items-center gap-2 text-primary-600 hover:text-primary-700 dark:text-primary-500 dark:hover:text-primary-400 text-sm font-medium transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18"></path>
            </svg>
            Return to site
        </a>
        <button id="theme-toggle-button" class="absolute top-6 right-6 z-50 p-2 rounded-md text-base-500 hover:bg-base-200 dark:text-base-400 dark:hover:bg-base-700 transition-colors" type="button" aria-label="Toggle Theme">
            <svg id="theme-toggle-sun" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"></path>
            </svg>
            <svg id="theme-toggle-moon" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z"></path>
            </svg>
        </button>
        <div class="w-full max-w-md">
            <header id="kc-header" class="mb-8 self-start w-full">
                <div class="text-sm font-semibold text-base-900 dark:text-base-100 mb-1">Welcome back to</div>
                <h1 class="font-bold text-primary-600 dark:text-primary-500 text-2xl">
                    <span id="kc-header-wrapper">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</span>
                </h1>
                <hr class="mt-4 border-base-200 dark:border-base-700 w-full"/>
            </header>
            <div class="w-full relative">

                <main>
                    <div class="${properties.kcLoginMainHeader!}">
                        <h2 class="hidden font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mb-4 text-left" id="kc-page-title"><#nested "header"></h2>
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
    <div class="hidden lg:flex lg:flex-col lg:justify-between lg:relative bg-cover bg-center bg-no-repeat" style="background-image: url('${url.resourcesPath}/${properties.bgImage}');">
        <div class="absolute inset-0 bg-base-900/40 mix-blend-multiply"></div>
        <div class="relative z-10 p-12 text-white mt-auto">
            <blockquote class="text-2xl font-semibold mb-4">Start building your next great application.</blockquote>
            <p class="text-base-300">Join thousands of developers using our platform.</p>
        </div>
    </div>
</div>

</body>
</html>
</#macro>

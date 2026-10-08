<#import "field.ftl" as field>
<#import "footer.ftl" as loginFooter>
<#import "scripts.ftl" as scriptMacro>
<#--
  Shared login layout for every unfold variant. The variant picks its shell with the
  `unfoldLayout` theme property: "centered" (default, unfold-default) or "split" (unfold-full).
  Targets Keycloak >= 26.8 and follows its keycloak.v2 template.ftl; keep the two in sync on upgrades.
-->
<#-- darkMode: theme property darkMode=true AND the realm's "Dark mode" switch (computed by Keycloak) -->
<#assign unfoldDarkMode = darkMode>
<#assign unfoldSplit = (properties.unfoldLayout!'centered') == 'split'>

<#macro username>
  <#assign label>
    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
  </#assign>
  <div class="flex flex-col gap-2 mb-5">
    <label for="kc-attempted-username" class="${field.labelClass}">${label}</label>
    <div class="flex gap-2">
      <input id="kc-attempted-username" class="${field.inputClass}" value="${auth.attemptedUsername}" readonly>
      <a id="reset-login" href="${url.loginRestartFlowUrl}" title="${msg('restartLoginTooltip')}" aria-label="${msg('restartLoginTooltip')}"
         class="flex items-center px-3 rounded-default border border-base-200 text-base-500 hover:bg-base-100 hover:text-primary-600 dark:border-base-700 dark:text-base-400 dark:hover:bg-base-800 transition-colors">
        <i class="fa-sync-alt fas" aria-hidden="true"></i>
      </a>
    </div>
  </div>
</#macro>

<#macro themeToggle positionClass>
  <#if unfoldDarkMode>
    <button id="theme-toggle-button" class="${positionClass} z-50 p-2 rounded-md text-base-500 hover:bg-base-200 dark:text-base-400 dark:hover:bg-base-700 transition-colors" type="button" aria-label="${msg('unfoldToggleTheme')}" aria-pressed="false">
        <svg id="theme-toggle-sun" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"></path>
        </svg>
        <svg id="theme-toggle-moon" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z"></path>
        </svg>
    </button>
  </#if>
</#macro>

<#macro localeSwitcher>
  <#if realm.internationalizationEnabled && locale.supported?size gt 1>
    <div id="kc-locale" class="mb-4 flex justify-end">
      <select id="login-select-toggle" aria-label="${msg("languages")}" onchange="if (this.value) window.location.href=this.value"
              class="rounded-default border border-base-200 bg-white px-2 py-1 text-sm text-font-default-light dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark focus:ring-2 focus:ring-primary-500/20 focus:outline-none">
        <#list locale.supported?sort_by("label") as l>
          <option value="${l.url}" ${(l.languageTag == locale.currentLanguageTag)?then('selected','')}>${l.label}</option>
        </#list>
      </select>
    </div>
  </#if>
</#macro>

<#macro brandHeader>
  <#if properties.unfoldLogoUrl?has_content>
    <div class="flex ${unfoldSplit?then('justify-start', 'justify-center')} mb-2">
        <img src="${url.resourcesPath}/${properties.unfoldLogoUrl}" alt="${realm.displayName!realm.name}" class="h-10 max-w-full dark:hidden" id="kc-logo-light">
        <img src="${url.resourcesPath}/${properties.unfoldLogoUrlDark!properties.unfoldLogoUrl}" alt="${realm.displayName!realm.name}" class="h-10 max-w-full hidden dark:block" id="kc-logo-dark">
    </div>
  <#elseif unfoldSplit>
    <div class="text-sm font-semibold text-base-900 dark:text-base-100 mb-1">${msg("unfoldWelcomeBackTo")}</div>
    <h1 class="font-bold text-primary-600 dark:text-primary-500 text-2xl">
        <span id="kc-header-wrapper">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</span>
    </h1>
  <#else>
    <h1 class="font-semibold text-center">
        <span class="text-base-900 dark:text-base-100 text-base">${msg("unfoldWelcomeBackTo")}</span>
        <span id="kc-header-wrapper" class="font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mt-1">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</span>
    </h1>
  </#if>
</#macro>

<#macro requiredFieldsNote>
  <p class="mb-4 text-xs text-base-500 dark:text-base-400"><span class="text-red-600" aria-hidden="true">*</span> ${msg("requiredFields")}</p>
</#macro>

<#macro secondaryActionForm id name value label>
  <form id="kc-${id}-form" action="${url.loginAction}" method="post" class="mt-4" novalidate="novalidate">
      <input type="hidden" name="${name}" value="${value}"/>
      <a id="${id}" href="#" onclick="document.forms['kc-${id}-form'].requestSubmit();return false;"
         class="text-primary-600 hover:text-primary-700 dark:text-primary-500">${label}</a>
  </form>
</#macro>

<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${lang}"<#if realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="light${unfoldDarkMode?then(' dark', '')}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <#if unfoldDarkMode>
        <#-- Synchronous on purpose: applies the theme class before first paint (no flash of the wrong theme) -->
        <script src="${url.resourcesPath}/js/theme-toggle.js"></script>
    </#if>

    <#if properties.meta?has_content>
        <#assign metaList = properties.meta?split(' ')>
        <#list metaList as meta>
            <#assign metaParts = meta?split('==')>
            <meta name="${metaParts[0]}" content="${metaParts[1]}"/>
        </#list>
    </#if>
    <title>${title!msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" type="image/svg+xml" href="${url.resourcesPath}/img/favicon.svg" />
    <#if properties.stylesCommon?has_content>
        <#assign stylesCommonList = properties.stylesCommon?split(' ')>
        <#list stylesCommonList as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#assign stylesList = properties.styles?split(' ')>
        <#list stylesList as style>
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
    <@scriptMacro.kwScripts/>
</head>

<body id="keycloak-bg" class="antialiased bg-base-50 font-sans text-font-default-light text-sm dark:bg-base-900 dark:text-font-default-dark login ${unfoldSplit?then('m-0 p-0', '')} ${properties.kcBodyClass!} ${bodyClass}" data-page-id="login-${pageId}">

<#if unfoldSplit>
<div id="page" class="min-h-screen grid grid-cols-1 lg:grid-cols-2 w-full">
    <div class="flex flex-col justify-center items-center w-full bg-base-50 dark:bg-base-900 px-4 sm:px-6 lg:px-12 py-12 relative">
        <#if properties.kcLogoLink?has_content>
            <a id="kc-back-link" href="${properties.kcLogoLink}" class="absolute top-6 left-6 z-50 flex items-center gap-2 text-primary-600 hover:text-primary-700 dark:text-primary-500 dark:hover:text-primary-400 text-sm font-medium transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18"></path>
                </svg>
                ${msg("unfoldReturnToSite")}
            </a>
        </#if>
        <@themeToggle positionClass="absolute top-6 right-6"/>
        <div class="w-full max-w-md">
            <header id="kc-header" class="mb-8 self-start w-full">
                <@brandHeader/>
                <hr class="mt-4 border-base-200 dark:border-base-700 w-full"/>
            </header>
            <div class="w-full relative">
<#else>
<div id="page" class="min-h-screen flex flex-col justify-center items-center py-12 sm:px-6 lg:px-8 w-full ${properties.kcLogin!}">
    <@themeToggle positionClass="fixed top-4 right-4 sm:top-6 sm:right-6"/>
    <div class="w-full sm:max-w-md ${properties.kcLoginContainer!}">
        <div class="bg-white dark:bg-base-800 py-8 px-4 shadow-lg sm:rounded-xl sm:px-10 ${properties.kcLoginMain!} relative">
            <header id="kc-header" class="border-b border-base-200 mb-8 pb-6 dark:border-base-700">
                <@brandHeader/>
            </header>
</#if>

            <main>
                <@localeSwitcher/>
                <div class="${properties.kcLoginMainHeader!}">
                    <h2 class="<#if unfoldSplit>sr-only<#else>block</#if> font-semibold text-primary-600 tracking-tight text-xl dark:text-primary-500 mb-4 text-left" id="kc-page-title"><#nested "header"></h2>
                </div>

                <div class="${properties.kcLoginMainBody!}">
                    <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
                        <#if displayRequiredFields><@requiredFieldsNote/></#if>
                    <#else>
                        <#if displayRequiredFields><@requiredFieldsNote/></#if>
                        <div id="kc-username">
                            <#nested "show-username">
                            <@username/>
                        </div>
                    </#if>

                    <#-- App-initiated actions should not see warning messages about the need to complete the action during login. -->
                    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                        <div class="mb-4 ${properties.kcAlertClass!} pf-m-${(message.type = 'error')?then('danger', message.type)}">
                            <span class="${properties.kcAlertIconClass!}">
                                <i class="fas <#if message.type = 'success'>fa-check-circle<#elseif message.type = 'warning'>fa-exclamation-triangle<#elseif message.type = 'error'>fa-exclamation-circle<#else>fa-info-circle</#if>" aria-hidden="true"></i>
                            </span>
                            <span class="${properties.kcAlertTitleClass!} kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                        </div>
                    </#if>

                    <#nested "form">

                    <#if auth?has_content && auth.showTryAnotherWayLink()>
                        <@secondaryActionForm id="try-another-way" name="tryAnotherWay" value="on" label=msg("doTryAnotherWay")/>
                    </#if>

                    <#if switchOrganizationEnabled?? && switchOrganizationEnabled>
                        <@secondaryActionForm id="switch-organization" name="switchOrganization" value="true" label=msg("doSwitchOrganization")/>
                    </#if>

                    <#nested "socialProviders">
                </div>

                <#if displayInfo>
                    <div id="kc-info" class="mt-6 text-sm text-base-600 dark:text-base-400 ${properties.kcLoginMainFooter!}">
                        <#nested "info">
                    </div>
                </#if>

                <@loginFooter.content/>
            </main>

<#if unfoldSplit>
            </div>
        </div>
    </div>
    <div id="kc-hero" class="hidden lg:flex lg:flex-col lg:justify-between lg:relative bg-cover bg-center bg-no-repeat" style="background-image: url('${url.resourcesPath}/${properties.bgImage!'img/login-bg.jpg'}');">
        <div class="absolute inset-0 bg-base-900/40 mix-blend-multiply"></div>
        <div class="relative z-10 p-12 text-white mt-auto">
            <blockquote class="text-2xl font-semibold mb-4">${properties.unfoldQuote!msg("unfoldQuote")}</blockquote>
            <p class="text-base-300">${properties.unfoldQuoteSubtext!msg("unfoldQuoteSubtext")}</p>
        </div>
    </div>
</div>
<#else>
        </div>
    </div>
</div>
</#if>

</body>
</html>
</#macro>

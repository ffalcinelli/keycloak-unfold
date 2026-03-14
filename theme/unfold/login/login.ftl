<#import "template.ftl" as layout>
<#import "field.ftl" as field>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <div id="kc-form">
          <div id="kc-form-wrapper">
            <#if realm.password>
                <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="flex flex-col gap-3 mt-6">
                    <#if !usernameHidden??>
                        <#assign label>
                            <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                        </#assign>

                        <div class="flex flex-col group mb-5">
                            <div class="flex flex-col gap-2">
                                <label for="username" class="block font-semibold text-font-important-light dark:text-font-important-dark">
                                    ${label}
                                    <span class="text-red-600">*</span>
                                </label>
                                <input tabindex="1" id="username" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="username"
                                       aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                />
                                <#if messagesPerField.existsError('username','password')>
                                    <span id="input-error" class="text-red-600 text-sm mt-1" aria-live="polite">
                                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>
                    </#if>

                    <div class="flex flex-col group mb-5">
                        <div class="flex flex-col gap-2">
                            <label for="password" class="block font-semibold text-font-important-light dark:text-font-important-dark">
                                ${msg("password")}
                                <span class="text-red-600">*</span>
                            </label>

                            <div class="relative w-full">
                                <input tabindex="2" id="password" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full" name="password" type="password" autocomplete="current-password"
                                       aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                />
                                <button class="absolute inset-y-0 right-0 flex items-center px-3 text-base-400 hover:text-base-600" type="button" aria-label="${msg('showPassword')}"
                                        aria-controls="password"  data-password-toggle
                                        data-icon-show="fa-eye fas" data-icon-hide="fa-eye-slash fas"
                                        data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                                    <i class="fa-eye fas" aria-hidden="true"></i>
                                </button>
                            </div>

                            <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                                <span id="input-error" class="text-red-600 text-sm mt-1" aria-live="polite">
                                        ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </div>

                    <div class="flex flex-row items-center justify-between mb-2">
                        <#if realm.rememberMe && !usernameHidden??>
                            <div class="flex items-center">
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" class="h-4 w-4 rounded border-base-300 text-primary-600 focus:ring-primary-600"
                                       <#if login.rememberMe??>checked</#if>>
                                <label for="rememberMe" class="ml-2 block text-sm text-font-default-light dark:text-font-default-dark">${msg("rememberMe")}</label>
                            </div>
                        </#if>
                    </div>

                    <div class="flex flex-col gap-3 mt-2">
                        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                        <button tabindex="4" class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors" name="login" id="kc-login" type="submit">
                            ${msg("doLogIn")}
                        </button>

                        <#if realm.resetPasswordAllowed>
                            <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer bg-base-100 border border-transparent dark:bg-base-800 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-200 dark:hover:bg-base-700 transition-colors">
                                ${msg("doForgotPassword")}
                            </a>
                        </#if>
                    </div>
                </form>
            </#if>
            </div>

        </div>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("doRegister")}</a></span>
                </div>
            </div>
        </#if>
        <#if properties.termsUrl?has_content || url.termsUrl??>
        <div id="kc-terms-and-conditions" class="mt-4 pt-4 border-t border-base-200 dark:border-base-800 text-center text-xs">
            By logging in, you agree to our <a href="${properties.termsUrl!url.termsUrl!'#'}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("termsTitle")}</a>.
        </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social?? && social.providers?has_content>
            <div id="kc-social-providers" class="mt-6 border-t border-base-200 dark:border-base-800 pt-6">
                <ul class="flex flex-col gap-3">
                    <#list social.providers as p>
                        <li>
                            <a href="${p.loginUrl}" class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-white dark:bg-base-900 dark:border-base-700 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-50 dark:hover:bg-base-800 transition-colors" id="social-${p.alias}">
                                <#if p.iconClasses?has_content>
                                    <i class="${p.iconClasses} text-xl mr-2" aria-hidden="true"></i>
                                </#if>
                                <span class="flex-grow text-center">${p.displayName!}</span>
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>

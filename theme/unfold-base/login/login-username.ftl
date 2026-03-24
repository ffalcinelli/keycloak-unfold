<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username') displayInfo=(realm.password && realm.registrationAllowed && !registrationDisabled??); section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <#if realm.password>
                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}"
                          method="post" class="flex flex-col gap-3 mt-6">
                        <#if !usernameHidden??>
                            <#assign label>
                                <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                            </#assign>
                            <div class="flex flex-col group mb-5">
                                <div class="flex flex-col gap-2">
                                    <label for="username" class="${field.labelClass}">${label}</label>

                                    <input tabindex="1" id="username" class="${field.inputClass}" name="username"
                                           value="${(login.username!'')}"
                                           type="text" autofocus autocomplete="username"
                                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                    />

                                    <#if messagesPerField.existsError('username')>
                                        <span id="input-error-username" class="${field.errorClass}" aria-live="polite">
                                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                                        </span>
                                    </#if>
                                </div>
                            </div>
                        </#if>

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
                            <button tabindex="4" class="${field.primaryButtonClass}" name="login" id="kc-login" type="submit">
                                ${msg("doLogIn")}
                            </button>
                        </div>
                    </form>
                </#if>
            </div>
        </div>

    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="6"
                                                 href="${url.registrationUrl}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("doRegister")}</a></span>
                </div>
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

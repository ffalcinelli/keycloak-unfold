<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="post">
            <div class="flex flex-col group mb-5">
                <div class="flex flex-col gap-2">
                    <label for="username" class="block font-semibold text-font-important-light dark:text-font-important-dark">
                        <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                        <span class="text-red-600">*</span>
                    </label>
                    <input type="text" id="username" name="username" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full" autofocus value="${(auth.attemptedUsername!'')}" aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"/>

                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="text-red-600 text-sm mt-1" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="flex flex-col gap-3 mt-2">
                <button class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors" type="submit">
                    ${msg("doSubmit")}
                </button>
                <a href="${url.loginUrl}" class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer bg-base-100 border border-transparent dark:bg-base-800 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-200 dark:hover:bg-base-700 transition-colors">
                    ${msg("backToLogin")}
                </a>
            </div>
        </form>
    <#elseif section = "info" >
        <#if realm.duplicateEmailsAllowed>
            ${msg("emailInstructionUsername")}
        <#else>
            ${msg("emailInstruction")}
        </#if>
    </#if>
</@layout.registrationLayout>

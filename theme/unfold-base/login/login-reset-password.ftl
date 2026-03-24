<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="post">
            <div class="flex flex-col group mb-5">
                <div class="flex flex-col gap-2">
                    <label for="username" class="${field.labelClass}">
                        <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                        <span class="text-red-600">*</span>
                    </label>
                    <input type="text" id="username" name="username" class="${field.inputClass}" autofocus value="${kcSanitize(auth.attemptedUsername!'')}" aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"/>

                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="${field.errorClass}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="flex flex-col gap-3 mt-2">
                <button class="${field.primaryButtonClass}" type="submit">
                    ${msg("doSubmit")}
                </button>
                <a href="${url.loginUrl}" class="${field.secondaryButtonClass}">
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

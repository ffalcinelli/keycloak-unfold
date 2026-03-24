<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<#import "user-profile-commons.ftl" as userProfileCommons>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('global') displayRequiredFields=true; section>
    <#if section = "header">
        ${msg("loginProfileTitle")}
    <#elseif section = "form">
        <form id="kc-update-profile-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="post">
            <#if user.editUsernameAllowed>
                <div class="flex flex-col group mb-5">
                    <div class="flex flex-col gap-2">
                        <label for="username" class="${field.labelClass}">${msg("username")}<span class="text-red-600">*</span></label>
                        <input type="text" id="username" name="username" value="${(user.username!'')}"
                               class="${field.inputClass}"
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

            <@userProfileCommons.userProfileFormFields />

            <div class="flex flex-col gap-3 mt-2">
                <button class="${field.primaryButtonClass}" type="submit">
                    ${msg("doSubmit")}
                </button>
                <#if isAppInitiatedAction??>
                    <button class="${field.secondaryButtonClass}" type="submit" name="cancel-aia" value="true">
                        ${msg("doCancel")}
                    </button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

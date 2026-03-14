<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('global') displayRequiredFields=true; section>
    <#if section = "header">
        ${msg("loginProfileTitle")}
    <#elseif section = "form">
        <form id="kc-update-profile-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="post">
            <#if user.editUsernameAllowed>
                <div class="flex flex-col group mb-5">
                    <div class="flex flex-col gap-2">
                        <label for="username" class="block font-semibold text-font-important-light dark:text-font-important-dark">${msg("username")}<span class="text-red-600">*</span></label>
                        <input type="text" id="username" name="username" value="${(user.username!'')}"
                               class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full"
                               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                        />

                        <#if messagesPerField.existsError('username')>
                            <span id="input-error-username" class="text-red-600 text-sm mt-1" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('username'))?no_esc}
                            </span>
                        </#if>
                    </div>
                </div>
            </#if>

            <@userProfileCommons.userProfileFormFields />

            <div class="flex flex-col gap-3 mt-2">
                <button class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors" type="submit">
                    ${msg("doSubmit")}
                </button>
                <#if isAppInitiatedAction??>
                    <button class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer bg-base-100 border border-transparent dark:bg-base-800 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-200 dark:hover:bg-base-700 transition-colors" type="submit" name="cancel-aia" value="true">
                        ${msg("doCancel")}
                    </button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

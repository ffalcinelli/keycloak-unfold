<#import "template.ftl" as layout>
<#import "password-commons.ftl" as passwordCommons>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username"
                   readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <div class="flex flex-col group mb-5">
                <div class="flex flex-col gap-2">
                    <label for="password-new" class="block font-semibold text-font-important-light dark:text-font-important-dark">${msg("passwordNew")}<span class="text-red-600">*</span></label>
                    <div class="relative w-full">
                        <input type="password" id="password-new" name="password-new" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full"
                               autofocus autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        />
                        <button class="absolute inset-y-0 right-0 flex items-center px-3 text-base-400 hover:text-base-600" type="button" aria-label="${msg('showPassword')}"
                                aria-controls="password-new"  data-password-toggle
                                data-icon-show="fa-eye fas" data-icon-hide="fa-eye-slash fas"
                                data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                            <i class="fa-eye fas" aria-hidden="true"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="text-red-600 text-sm mt-1" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="flex flex-col group mb-5">
                <div class="flex flex-col gap-2">
                    <label for="password-confirm" class="block font-semibold text-font-important-light dark:text-font-important-dark">${msg("passwordConfirm")}<span class="text-red-600">*</span></label>
                    <div class="relative w-full">
                        <input type="password" id="password-confirm" name="password-confirm" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full"
                               autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />
                        <button class="absolute inset-y-0 right-0 flex items-center px-3 text-base-400 hover:text-base-600" type="button" aria-label="${msg('showPassword')}"
                                aria-controls="password-confirm"  data-password-toggle
                                data-icon-show="fa-eye fas" data-icon-hide="fa-eye-slash fas"
                                data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                            <i class="fa-eye fas" aria-hidden="true"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password-confirm')>
                        <span id="input-error-password-confirm" class="text-red-600 text-sm mt-1" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

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
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    </#if>
</@layout.registrationLayout>

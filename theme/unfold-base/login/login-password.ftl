<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password'); section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}"
                      method="post" class="flex flex-col gap-3 mt-6">
                    <div class="flex flex-col group mb-5">
                        <div class="flex flex-col gap-2">
                            <label for="password" class="block font-semibold text-font-important-light dark:text-font-important-dark">${msg("password")}</label>
                            <div class="relative w-full">
                                <input tabindex="2" id="password" name="password" type="password" autocomplete="current-password" class="border border-base-200 bg-white font-medium min-w-20 placeholder-base-400 rounded-default shadow-xs text-font-default-light text-sm focus:outline-2 focus:-outline-offset-2 focus:outline-primary-600 group-[.errors]:border-red-600 focus:group-[.errors]:outline-red-600 dark:bg-base-900 dark:border-base-700 dark:text-font-default-dark dark:group-[.errors]:border-red-500 dark:focus:group-[.errors]:outline-red-500 dark:scheme-dark group-[.primary]:border-transparent disabled:!bg-base-50 dark:disabled:!bg-base-800 px-3 py-2 w-full"
                                       aria-invalid="<#if messagesPerField.existsError('password')>true</#if>"
                                       autofocus
                                />
                                <button class="absolute inset-y-0 right-0 flex items-center px-3 text-base-400 hover:text-base-600" type="button" aria-label="${msg('showPassword')}"
                                        aria-controls="password"  data-password-toggle
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

                    <div class="flex flex-col gap-3 mt-2">
                        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                        <button tabindex="4" class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors" name="login" id="kc-login" type="submit">
                            ${msg("doLogIn")}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>

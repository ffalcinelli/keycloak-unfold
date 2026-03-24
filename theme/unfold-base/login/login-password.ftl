<#import "template.ftl" as layout>
<#import "field.ftl" as field>
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
                            <label for="password" class="${field.labelClass}">${msg("password")}</label>
                            <div class="relative w-full">
                                <input tabindex="2" id="password" name="password" type="password" autocomplete="current-password" class="${field.inputClass}"
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
                                <span id="input-error-password" class="${field.errorClass}" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('password'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </div>

                    <div class="flex flex-col gap-3 mt-2">
                        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                        <button tabindex="4" class="${field.primaryButtonClass}" name="login" id="kc-login" type="submit">
                            ${msg("doLogIn")}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>

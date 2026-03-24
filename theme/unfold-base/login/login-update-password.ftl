<#import "template.ftl" as layout>
<#import "field.ftl" as field>
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
                    <label for="password-new" class="${field.labelClass}">${msg("passwordNew")}<span class="text-red-600">*</span></label>
                    <div class="relative w-full">
                        <input type="password" id="password-new" name="password-new" class="${field.inputClass}"
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
                        <span id="input-error-password" class="${field.errorClass}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="flex flex-col group mb-5">
                <div class="flex flex-col gap-2">
                    <label for="password-confirm" class="${field.labelClass}">${msg("passwordConfirm")}<span class="text-red-600">*</span></label>
                    <div class="relative w-full">
                        <input type="password" id="password-confirm" name="password-confirm" class="${field.inputClass}"
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
                        <span id="input-error-password-confirm" class="${field.errorClass}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

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
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<#import "user-profile-commons.ftl" as userProfileCommons>
<#import "register-commons.ftl" as registerCommons>
<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${msg("registerTitle")}
        </#if>
    <#elseif section = "form">
        <form id="kc-register-form" class="flex flex-col gap-3 mt-6" action="${url.registrationAction}" method="post">

            <@userProfileCommons.userProfileFormFields; callback, attribute>
                <#if callback = "afterField">
                <#-- render password fields just under the username or email (if used as username) -->
                    <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
                        <div class="flex flex-col group mb-5">
                            <div class="flex flex-col gap-2">
                                <label for="password" class="${field.labelClass}">${msg("password")}<span class="text-red-600">*</span></label>
                                <div class="relative w-full">
                                    <input type="password" id="password" class="${field.inputClass}" name="password"
                                           autocomplete="new-password"
                                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
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

                        <div class="flex flex-col group mb-5">
                            <div class="flex flex-col gap-2">
                                <label for="password-confirm"
                                       class="${field.labelClass}">${msg("passwordConfirm")}<span class="text-red-600">*</span></label>
                                <div class="relative w-full">
                                    <input type="password" id="password-confirm" class="${field.inputClass}"
                                           name="password-confirm" autocomplete="new-password"
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
                    </#if>
                </#if>
            </@userProfileCommons.userProfileFormFields>

            <@registerCommons.termsAcceptance/>

            <#if recaptchaRequired?? && (recaptchaVisible!false)>
                <div class="flex flex-col group mb-5">
                    <div class="flex flex-col gap-2">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                    </div>
                </div>
            </#if>

            <div class="flex flex-col gap-3 mt-2">
                <#if recaptchaRequired?? && !(recaptchaVisible!false)>
                    <script>
                        function onSubmitRecaptcha(token) {
                            document.getElementById("kc-register-form").requestSubmit();
                        }
                    </script>
                    <button class="${field.primaryButtonClass} g-recaptcha"
                        data-sitekey="${recaptchaSiteKey}" data-callback='onSubmitRecaptcha' data-action='${recaptchaAction}' type="submit">
                        ${msg("doRegister")}
                    </button>
                <#else>
                    <button class="${field.primaryButtonClass}" type="submit">
                        ${msg("doRegister")}
                    </button>
                </#if>
                <a href="${url.loginUrl}" class="${field.secondaryButtonClass}">
                    ${msg("backToLogin")}
                </a>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

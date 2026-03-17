<#macro termsAcceptance>
    <#if termsAcceptanceRequired??>
        <div class="flex flex-col group mb-5">
            <div class="flex flex-col gap-2">
                ${msg("termsTitle")}
                <div id="kc-registration-terms-text" class="prose dark:prose-invert prose-sm max-w-none text-font-default-light dark:text-font-default-dark mb-2">
                    ${kcSanitize(msg("termsText"))?no_esc}
                </div>
            </div>
        </div>
        <div class="flex flex-row items-center justify-between mb-2">
            <div class="flex items-center">
                <input type="checkbox" id="termsAccepted" name="termsAccepted" class="h-4 w-4 rounded border-base-300 text-primary-600 focus:ring-primary-600"
                       aria-invalid="<#if messagesPerField.existsError('termsAccepted')>true</#if>"
                />
                <label for="termsAccepted" class="ml-2 block text-sm text-font-default-light dark:text-font-default-dark">${msg("acceptTerms")}</label>
            </div>
            <#if messagesPerField.existsError('termsAccepted')>
                <div class="text-red-600 text-sm mt-1">
                            <span id="input-error-terms-accepted" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('termsAccepted'))?no_esc}
                            </span>
                </div>
            </#if>
        </div>
    </#if>
</#macro>

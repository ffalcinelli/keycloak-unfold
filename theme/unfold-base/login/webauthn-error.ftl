<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true; section>
    <#if section = "header">
        ${kcSanitize(msg("webauthn-error-title"))?no_esc}
    <#elseif section = "form">

        <script type="text/javascript">
            refreshPage = () => {
                document.getElementById('isSetRetry').value = 'retry';
                document.getElementById('executionValue').value = '${execution}';
                document.getElementById('kc-error-credential-form').submit();
            }
        </script>

        <form id="kc-error-credential-form" class="flex flex-col gap-3 mt-6" action="${url.loginAction}"
              method="post">
            <input type="hidden" id="executionValue" name="authenticationExecution"/>
            <input type="hidden" id="isSetRetry" name="isSetRetry"/>
        </form>

        <input tabindex="4" onclick="refreshPage()" type="button"
               class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors mt-4"
               name="try-again" id="kc-try-again" value="${kcSanitize(msg("doTryAgain"))?no_esc}"
        />

        <#if isAppInitiatedAction??>
            <form action="${url.loginAction}" class="flex flex-col gap-3 mt-4" id="kc-webauthn-settings-form" method="post">
                <button type="submit"
                        class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer bg-base-100 border border-transparent dark:bg-base-800 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-200 dark:hover:bg-base-700 transition-colors"
                        id="cancelWebAuthnAIA" name="cancel-aia" value="true">${msg("doCancel")}
                </button>
            </form>
        </#if>

    </#if>
</@layout.registrationLayout>
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("pageExpiredTitle")}
    <#elseif section = "form">
        <div id="kc-expired-message" class="text-center flex flex-col items-center gap-4">
            <p id="instruction1" class="instruction mb-4 text-base-600 dark:text-base-400">
                ${msg("pageExpiredMsg1")} <a id="loginRestartLink" href="${url.loginRestartFlowUrl}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("pageExpiredMsg2")}</a>.
            </p>
        </div>
    </#if>
</@layout.registrationLayout>

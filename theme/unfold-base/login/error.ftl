<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("errorTitle")}
    <#elseif section = "form">
        <div id="kc-error-message" class="text-center flex flex-col items-center gap-4">
            <p class="instruction text-red-600 dark:text-red-400 font-medium mb-4">${kcSanitize(message.summary)?no_esc}</p>
            <#if client?? && client.baseUrl?has_content>
                <p><a id="backToApplication" href="${client.baseUrl}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("backToApplication")}</a></p>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>

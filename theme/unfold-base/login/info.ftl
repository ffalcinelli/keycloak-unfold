<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(messageHeader)?no_esc}
        <#else>
            ${kcSanitize(message.summary)?no_esc}
        </#if>
    <#elseif section = "form">
        <div id="kc-info-message" class="text-center flex flex-col items-center gap-4">
            <p class="instruction mb-4 text-base-600 dark:text-base-400">
                ${kcSanitize(message.summary)?no_esc}
                <#if requiredActions??>
                    <#list requiredActions>: <b><#items as reqAction>${msg("requiredAction.${reqAction}")}<#sep>, </#items></b></#list>
                </#if>
            </p>
            <#if skipLink??>
            <#else>
                <#if pageRedirectUri??>
                    <#if !pageRedirectUri?trim?lower_case?starts_with("javascript:") && !pageRedirectUri?trim?lower_case?starts_with("data:") && !pageRedirectUri?trim?lower_case?starts_with("vbscript:")>
                        <p><a href="${pageRedirectUri}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("backToApplication")}</a></p>
                    </#if>
                <#elseif actionUri??>
                    <#if !actionUri?trim?lower_case?starts_with("javascript:") && !actionUri?trim?lower_case?starts_with("data:") && !actionUri?trim?lower_case?starts_with("vbscript:")>
                        <p><a href="${actionUri}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("proceedWithAction")}</a></p>
                    </#if>
                <#elseif client?? && client.baseUrl?has_content>
                    <#if !client.baseUrl?trim?lower_case?starts_with("javascript:") && !client.baseUrl?trim?lower_case?starts_with("data:") && !client.baseUrl?trim?lower_case?starts_with("vbscript:")>
                        <p><a href="${client.baseUrl}" class="font-semibold text-primary-600 hover:text-primary-700 dark:text-primary-500">${msg("backToApplication")}</a></p>
                    </#if>
                </#if>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>

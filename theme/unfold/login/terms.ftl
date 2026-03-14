<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("termsTitle")}
    <#elseif section = "form">
    <div id="kc-terms-text" class="prose dark:prose-invert prose-sm max-w-none text-font-default-light dark:text-font-default-dark">
        ${kcSanitize(msg("termsText"))?no_esc}
    </div>
    <form class="flex flex-col gap-3 mt-6" action="${url.loginAction}" method="POST">
        <button class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer border border-base-200 bg-primary-600 border-transparent text-white w-full hover:bg-primary-700 transition-colors" name="accept" id="kc-accept" type="submit">
            ${msg("doAccept")}
        </button>
        <button class="font-medium flex group items-center gap-2 px-3 py-2 relative rounded-default justify-center whitespace-nowrap cursor-pointer bg-base-100 border border-transparent dark:bg-base-800 text-font-default-light dark:text-font-default-dark w-full hover:bg-base-200 dark:hover:bg-base-700 transition-colors" name="cancel" id="kc-decline" type="submit">
            ${msg("doDecline")}
        </button>
    </form>
    <div class="clearfix"></div>
    </#if>
</@layout.registrationLayout>

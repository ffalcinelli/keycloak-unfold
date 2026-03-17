<#macro emailLayout>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #f8fafc; /* slate-50 */
            color: #334155; /* slate-700 */
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            background-color: #ffffff;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            border: 1px solid #e2e8f0; /* slate-200 */
            padding: 32px;
        }
        .header {
            margin-bottom: 24px;
            text-align: center;
            color: #0f172a; /* slate-900 */
            font-size: 24px;
            font-weight: 600;
        }
        .content {
            line-height: 1.6;
        }
        .button {
            display: inline-block;
            background-color: #0f172a; /* slate-900 */
            color: #ffffff;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 0.375rem; /* rounded-md */
            font-weight: 500;
            margin-top: 16px;
        }
        .footer {
            margin-top: 32px;
            font-size: 14px;
            color: #64748b; /* slate-500 */
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            ${kcSanitize(msg("emailTitle"))?no_esc}
        </div>
        <div class="content">
            <#nested>
        </div>
        <div class="footer">
            <p>${kcSanitize(msg("emailFooter"))?no_esc}</p>
        </div>
    </div>
</body>
</html>
</#macro>

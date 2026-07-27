# Security Policy

## Supported Versions

Currently, the following versions of `keycloak-unfold-theme` are supported with security updates:

| Version | Status                |
| ------- | --------------------- |
| 26.x    | :white_check_mark: Supported   |

## Reporting a Vulnerability

If you discover a potential security vulnerability in `keycloak-unfold-theme`, please do **not** open a public issue. Instead, report it privately to the maintainers:

- Fabio Falcinelli: [fabio.falcinelli@gmail.com](mailto:fabio.falcinelli@gmail.com)

We aim to acknowledge receipt of your report as soon as possible (typically within a few business days). Please note that while we take security seriously, we are a community-maintained project and cannot guarantee a specific resolution timeframe. We will provide updates as we investigate the issue and work toward a fix.

### What to Include in a Report

To help us address the issue quickly, please include:
- A clear description of the vulnerability.
- A minimal reproducible example (PoC) if possible.
- Any potential impact or exploitation scenarios.

## Security Best Practices for keycloak-unfold-theme Users

`keycloak-unfold-theme` is a custom theme for Keycloak. To ensure your usage remains secure:

1.  **Keep Keycloak and the Theme Updated**: Ensure you are using a supported version of Keycloak and the latest version of `keycloak-unfold-theme` to benefit from security fixes in both Keycloak's core and this theme.
2.  **Template Customization**: If you customize the theme's FreeMarker templates (`.ftl`), make sure to properly escape dynamic values to prevent Cross-Site Scripting (XSS) vulnerabilities.
3.  **Secure Deployment**: Deploy the theme JAR or directory with proper access controls on your Keycloak server. Restrict read/write permissions to authorized system users/processes only.
4.  **Dependencies**: If building from source, keep NPM dependencies updated to avoid vulnerabilities in build-time tooling.

## Disclosure Policy

We follow a responsible disclosure policy:
1.  Acknowledge the report.
2.  Investigate and confirm the vulnerability.
3.  Work on a fix.
4.  Release a new version with the fix.
5.  Publicly disclose the vulnerability (e.g., via GitHub Security Advisories) after a fix is available and users have had time to update.

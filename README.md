# Keycloak Unfold

> [!WARNING]
> **Disclaimer**: This project is experimentally written almost entirely by AI. Any usage of this software should keep this in mind, and the execution of this software is at your own risk.

Keycloak Unfold is a modular custom theme for Keycloak designed to emulate the clean, modern aesthetics of the popular [Django Unfold Theme](https://github.com/unfoldadmin/django-unfold). It builds on Keycloak's native `v2` theme and overrides PatternFly 5 CSS variables to deliver a premium user interface out of the box.

---

## Key Features

- **Unfold Aesthetics**: Clean layouts, high-contrast borders, refined typography, and slate neutral tones.
- **Dark Mode Support**: Seamless integration supporting both automatic detection via system settings (`prefers-color-scheme`) and manual overrides via a interactive toggle.
- **Tailwind CSS Utility Integration**: Build custom styles using Tailwind CSS v4 in your FreeMarker templates (`.ftl`).
- **Flexible Theme Variants**: Toggle between standard centered and split-screen visual flows.
- **Preconfigured Local Development**: Fast spin-up with Docker Compose and pre-populated demo realms.
- **Comprehensive E2E Suite**: Preconfigured Playwright tests validating functionality, styles, and dark mode toggles.

---

## Compatibility Matrix

Keycloak Unfold is versioned independently using [Semantic Versioning (SemVer)](https://semver.org/) starting from `0.0.1`.

| Theme Version              | Supported Keycloak | Tested Keycloak | Base Theme | PatternFly Version         | Django Unfold Alignment | Support Status |
| :------------------------- | :----------------- | :-------------- | :--------- | :------------------------- | :---------------------- | :------------- |
| `0.0.x` (current: `0.0.1`) | `26.x` (26.0.0+)   | `v26.7.0`       | `v2`       | PatternFly 5 (`--pf-v5-*`) | `v0.101.0`              | 🟢 Active      |

### Versioning Strategy

- **Major (`X.0.0`)**: Breaking template architecture redesigns or major Keycloak base theme upgrades.
- **Minor (`0.X.0`)**: New theme variants, feature additions, or layout enhancements.
- **Patch (`0.0.X`)**: Bug fixes, CSS refinements, and compatibility updates for Keycloak point releases.

For detailed design system and upstream version alignments, see [UNFOLD_VERSION.md](file:///home/fabio/Workspace/keycloak-unfold/UNFOLD_VERSION.md).

---

## Theme Architecture

The theme registration is defined in the [keycloak-themes.json](file:///home/fabio/Workspace/keycloak-unfold/src/main/resources/META-INF/keycloak-themes.json) configuration. The codebase follows a modular inheritance-based architecture:

```mermaid
graph TD
    A[Keycloak v2 Base Theme] --> B[unfold-base]
    B --> C[unfold-default]
    B --> D[unfold-full]
```

1. **`unfold-base`**: The core theme. It contains all modified FreeMarker templates (`.ftl`) for login, account, admin, and email modules, as well as shared CSS files, logos, and scripts (like dark mode logic).
2. **`unfold-default`**: Inherits from `unfold-base`. Delivers a clean, centered login layout. Keeps the Admin and Account consoles visually aligned with default Keycloak layout patterns, overriding only colors and typography.
3. **`unfold-full`**: Inherits from `unfold-base`. Delivers a premium split-screen layout with a configurable hero image background on the left and login actions on the right.

---

## Configuration & Customization Guide

### CSS Overrides & Design System

All key styling variables are defined in the central [unfold-common.css](file:///home/fabio/Workspace/keycloak-unfold/theme/unfold-base/common/resources/css/unfold-common.css) file. You can adjust colors, fonts, and border-radii by editing the custom properties:

```css
:root {
  /* Font Family */
  --pf-v5-global--FontFamily--sans-serif: 'Inter', sans-serif;

  /* Primary Theme Accent */
  --color-primary-600: #7c3aed; /* Light Mode Accent */
  --color-primary-500: #8b5cf6; /* Dark Mode Accent */

  /* Neutral Slates */
  --color-base-50: #f8fafc;
  --color-base-900: #0f172a;
}
```

### Customizing Variant Assets & Metadata

You can customize the background image or resources for specific variants using `theme.properties` configuration files:

- **`unfold-full` Background**: You can customize the split-screen image by modifying `bgImage=img/login-bg.jpg` in [theme/unfold-full/login/theme.properties](file:///home/fabio/Workspace/keycloak-unfold/theme/unfold-full/login/theme.properties).
- **Logos**: Place your custom SVG logo at `theme/unfold-base/login/resources/img/logo.svg`. The header leverages CSS classes to support light/dark variants (`#kc-logo-light` and `#kc-logo-dark`).

---

## Local Development

Ensure you have **Docker**, **Docker Compose**, and **Node.js** (v18+) installed.

### 1. Spin up Keycloak Dev Instance

Run the following command to start Keycloak:

```bash
docker compose up
```

This mounts local theme folders directly and imports the demo realm configurations from the [demo/](file:///home/fabio/Workspace/keycloak-unfold/demo/) directory. Keycloak is available at `http://localhost:8080`.

- **Admin Console Login**: `admin` / `admin`
- **Demo User Login**: `testuser` / `password`

### 2. Live Testing URLs

Three pre-configured demo realms are imported for verification:

- **Default Theme (Centered Login)**: [Default Account Console Demo](http://localhost:8080/realms/unfold-default-demo/account/)
- **Full Theme (Split-Screen Login)**: [Full Account Console Demo](http://localhost:8080/realms/unfold-full-demo/account/)
- **Standard Base Demo**: [Demo Realm Account](http://localhost:8080/realms/demo/account/)

---

## Tailwind CSS Build Pipeline

The project uses **Tailwind CSS v4** to build utilities. If you modify `.ftl` templates and add custom classes, you must compile the CSS.

- **Build CSS**:

  ```bash
  npm run build
  ```

  This runs `npx @tailwindcss/cli` minifying the output stylesheet.

- **Watch and Auto-compile (Recommended for development)**:
  ```bash
  npx @tailwindcss/cli -i ./theme/unfold-base/login/resources/css/tailwind-input.css -o ./theme/unfold-base/login/resources/css/tailwind.css --watch
  ```

---

## Packaging & Production Deployment

To deploy this theme on a production Keycloak cluster, package it as a JAR file (Keycloak best practice).

### Option A: Pack using NPM (Recommended for Frontend Devs)

Run the NPM packager script:

```bash
npm run package
```

This builds CSS, prepares the `META-INF` files, and generates a packaged archive (e.g., `keycloak-unfold-v0.0.1.jar`) in the root directory.

### Option B: Pack using Maven (Recommended for Java/DevOps Pipelines)

Compile using Maven (builds and runs tests under `/target`):

```bash
mvn clean package
```

This compiles the output JAR into the `target/` directory: `target/keycloak-unfold-v0.0.1.jar`.

### Production Installation Steps

1. Copy the compiled `.jar` file to the `providers/` directory of your Keycloak installation.
2. Run the Keycloak build step to register the new theme provider:
   ```bash
   bin/kc.sh build
   ```
3. Restart/Start Keycloak in production mode:
   ```bash
   bin/kc.sh start
   ```

---

## Post-Install Customization

Once the JAR is installed you can override any asset or property **without rebuilding the JAR**. Keycloak resolves theme resources with filesystem-first priority:

```
/opt/keycloak/themes/<theme-name>/   ← your overrides (WINS)
JAR: theme/<theme-name>/...          ← packaged defaults (fallback)
```

Place only the files you want to change in `/opt/keycloak/themes/`. Everything else loads from the JAR automatically. A fully annotated set of example override files is provided in the [`customization/`](customization/) directory.

### Logo

Drop your SVG files into `themes/unfold-base/login/resources/img/` keeping the default names — no config change required:

| File | Mode |
|---|---|
| `logo-light.svg` | Light mode |
| `logo-dark.svg` | Dark mode (falls back to light if absent) |
| `favicon.svg` | Browser tab icon |

If you prefer different filenames, set these in `themes/unfold-base/login/theme.properties`:

```properties
unfoldLogoUrl=img/my-logo.svg
unfoldLogoUrlDark=img/my-logo-dark.svg
```

### Background Image (`unfold-full` only)

Replace the file at `themes/unfold-full/login/resources/img/login-bg.jpg` — or set a custom path:

```properties
# themes/unfold-full/login/theme.properties
bgImage=img/my-hero.jpg
```

### All Configurable Properties

| Property | Theme | Default | Description |
|---|---|---|---|
| `unfoldLogoUrl` | `unfold-base/login` | `img/logo-light.svg` | Light mode logo path |
| `unfoldLogoUrlDark` | `unfold-base/login` | *(same as light)* | Dark mode logo path |
| `termsUrl` | `unfold-base/login` | `https://example.com/terms` | Terms of service link URL |
| `darkMode` | `unfold-base/login` | *(unset)* | Set any value to enable the dark/light toggle button |
| `bgImage` | `unfold-full/login` | `img/login-bg.jpg` | Split-screen background image |
| `kcLogoLink` | `unfold-full/login` | `#` | URL for the "Return to site" back-link |
| `unfoldQuote` | `unfold-full/login` | *(built-in text)* | Marketing quote shown over the background |
| `unfoldQuoteSubtext` | `unfold-full/login` | *(built-in text)* | Subtext below the quote |

### Brand Color Override

To change the primary accent color without editing CSS inside the JAR, add a small override stylesheet. Copy [`customization/unfold-base/login/resources/css/my-brand.css`](customization/unfold-base/login/resources/css/my-brand.css) to your themes directory, edit the `--color-primary-*` values, then reference it in `themes/unfold-base/login/theme.properties`:

```properties
styles=css/unfold-common.css css/unfold.css css/login-widgets.css css/tailwind.css css/my-brand.css
```

### Docker Compose Example

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.7.0
    volumes:
      - ./keycloak-unfold-v0.0.1.jar:/opt/keycloak/providers/keycloak-unfold.jar:ro
      - ./my-overrides:/opt/keycloak/themes:ro
    command: start-dev
```

Where `my-overrides/` contains only the files you actually changed, mirroring the structure of the `customization/` directory.

---

## Testing & Quality Assurance

### Run Playwright E2E Tests

To install dependencies and execute the E2E verification test suite (which validates layout styling, button behaviors, and dark mode toggles):

```bash
npm install
npm run test
```

For interactive test debugging, run:

```bash
npx playwright test --ui
```

### Linters & Formatters

Keep the code base clean by running validation scripts before submitting pull requests:

- **Lint all files**: `npm run lint` (validates JavaScript with ESLint and CSS with Stylelint).
- **Check formatting**: `npm run format:check` (verifies compliance with Prettier formatting rules).
- **Auto-format code**: `npm run format` (formats all workspace stylesheets, templates, and scripts).

---

## Visual Previews

### Unfold Default Variant

The `unfold-default` variant focuses on a clean, "Keycloak-native" feel with custom accent colors.

| Login Page                                               | Account Console                                              |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| ![unfold-default-login](assets/unfold-default-login.png) | ![unfold-default-account](assets/unfold-default-account.png) |

### Unfold Full Variant

The `unfold-full` variant provides a highly customized split-screen, premium visual layout.

| Login Page                                         | Account Console                                        |
| -------------------------------------------------- | ------------------------------------------------------ |
| ![unfold-full-login](assets/unfold-full-login.png) | ![unfold-full-account](assets/unfold-full-account.png) |

---

## Credits & License

- Designed and inspired by the excellent [Django Unfold Theme](https://github.com/unfoldadmin/django-unfold).
- Distributed under the [MIT License](LICENSE).
- For reporting security vulnerabilities, please refer to our guidelines in [SECURITY.md](file:///home/fabio/Workspace/keycloak-unfold/SECURITY.md).

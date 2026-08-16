# Post-Install Customization Guide

This directory contains ready-to-use override templates for customizing `keycloak-unfold`
after it has been installed as a JAR file.

---

## How Keycloak Theme Layering Works

Keycloak resolves theme resources with a **filesystem-first** priority:

```
/opt/keycloak/themes/<theme-name>/   ← your overrides (WINS)
JAR: theme/<theme-name>/...          ← packaged defaults (fallback)
```

You only need to provide the **files you want to change**. Everything else
continues to load from the JAR transparently.

---

## Directory Structure

```
customization/
├── unfold-base/
│   └── login/
│       ├── theme.properties              ← Logo, terms URL, dark mode toggle, accent color
│       └── resources/
│           ├── img/
│           │   ├── PLACE_LOGOS_HERE.md   ← Drop logo-light.svg / logo-dark.svg / favicon.svg here
│           │   ├── logo-light.svg        ← (your file)
│           │   └── logo-dark.svg         ← (your file, optional)
│           └── css/
│               └── my-brand.css          ← Optional: brand color override stylesheet
└── unfold-full/
    └── login/
        ├── theme.properties              ← Background image, back-link URL, quote text
        └── resources/
            └── img/
                ├── PLACE_BACKGROUND_HERE.md   ← Drop login-bg.jpg here
                └── login-bg.jpg               ← (your file)
```

---

## Quickstart

### 1. Logo (both variants)

Drop your SVG logo files into `unfold-base/login/resources/img/` keeping the default names:

```
logo-light.svg   ← used in light mode
logo-dark.svg    ← used in dark mode (falls back to logo-light.svg if absent)
favicon.svg      ← browser tab icon (optional)
```

No `theme.properties` edit is needed if you keep the filenames. If you rename them,
set `unfoldLogoUrl` and `unfoldLogoUrlDark` in `unfold-base/login/theme.properties`.

### 2. Background Image (`unfold-full` only)

Drop your image into `unfold-full/login/resources/img/` keeping the name `login-bg.jpg`.

If you want a different filename, update `bgImage` in `unfold-full/login/theme.properties`:

```properties
bgImage=img/my-hero.jpg
```

### 3. Brand Colors

Copy `unfold-base/login/resources/css/my-brand.css` to your overrides directory,
edit the `--color-primary-*` values, then add the filename to your `theme.properties`:

```properties
styles=css/unfold-common.css css/unfold.css css/login-widgets.css css/tailwind.css css/my-brand.css
```

### 4. Split-Screen Quote Text (`unfold-full` only)

Add to `unfold-full/login/theme.properties`:

```properties
unfoldQuote=Secure. Simple. Yours.
unfoldQuoteSubtext=Powered by your company platform.
```

### 5. "Return to Site" Link (`unfold-full` only)

Add to `unfold-full/login/theme.properties`:

```properties
kcLogoLink=https://yoursite.com
```

### 6. Enable Dark Mode Toggle

Add to `unfold-base/login/theme.properties`:

```properties
darkMode=true
```

---

## Deployment Patterns

### Docker / Docker Compose

Mount your customization directory as the Keycloak themes volume alongside the JAR:

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.7.0
    volumes:
      - ./keycloak-unfold-v0.0.1.jar:/opt/keycloak/providers/keycloak-unfold.jar:ro
      - ./my-overrides:/opt/keycloak/themes:ro
    command: start-dev
```

Where `my-overrides/` contains only the files from this `customization/` directory
that you have actually changed.

### Kubernetes

Use a `ConfigMap` for small text files (theme.properties) and an `initContainer`
or persistent volume for binary assets (images):

```yaml
volumes:
  - name: theme-overrides
    configMap:
      name: keycloak-unfold-overrides
  - name: theme-images
    persistentVolumeClaim:
      claimName: keycloak-brand-images
```

### Bare-metal / VM

Copy your override files directly to the Keycloak installation:

```bash
cp -r my-overrides/* /opt/keycloak/themes/
```

No build step or restart is required when `KC_THEME_CACHEATTRIBUTE=false` (dev mode).
In production, restart Keycloak after changing theme files.

---

## All Configurable Properties

| Property | Theme | Default | Description |
|---|---|---|---|
| `unfoldLogoUrl` | `unfold-base/login` | `img/logo-light.svg` | Light mode logo (relative to resources/) |
| `unfoldLogoUrlDark` | `unfold-base/login` | *(same as light)* | Dark mode logo (falls back to `unfoldLogoUrl`) |
| `termsUrl` | `unfold-base/login` | `https://example.com/terms` | Terms of service link URL |
| `darkMode` | `unfold-base/login` | *(unset)* | Set any value to enable the dark/light toggle button |
| `bgImage` | `unfold-full/login` | `img/login-bg.jpg` | Split-screen background image (relative to resources/) |
| `kcLogoLink` | `unfold-full/login` | `#` | URL for the "Return to site" back-link |
| `unfoldQuote` | `unfold-full/login` | *(hardcoded fallback)* | Marketing quote shown over the background image |
| `unfoldQuoteSubtext` | `unfold-full/login` | *(hardcoded fallback)* | Subtext below the quote |

> **Favicon**: The path `img/favicon.svg` is hardcoded in `template.ftl`. To override it,
> simply replace the file — no property change needed.

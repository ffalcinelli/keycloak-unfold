# Post-Install Customization Guide

`my-brand/` is a ready-to-copy **child theme** for an installed `keycloak-unfold` JAR. It
changes only what you put in it (colors, logos, properties) and inherits everything else.
Requires Keycloak 26.8.0 or newer.

---

## How It Works

Keycloak does **not** merge a folder theme with a JAR theme of the same name. A folder called
`unfold-base` in `/opt/keycloak/themes/` would replace the packaged one entirely. Its
`parent=unfold-base` would then point at itself, which makes login requests hang.

Use a theme with its own name that extends the packaged one instead:

```
/opt/keycloak/themes/my-brand/login/theme.properties   parent=unfold-default (or unfold-full)
                     my-brand/...                      only the files you change
providers/keycloak-unfold.jar                          unfold-base, unfold-default, unfold-full
```

Resources (CSS, images, templates, messages) are looked up in `my-brand` first, then along
the parent chain into the JAR.

---

## Directory Structure

```
my-brand/
├── common/
│   ├── theme.properties                 ← empty; makes common/my-brand importable
│   └── resources/css/my-brand.css       ← brand colors, shared by login/account/admin
├── login/
│   ├── theme.properties                 ← parent variant, logo, terms URL, dark mode, unfold-full options
│   └── resources/img/                   ← logo-light.svg, logo-dark.svg, favicon.svg, login-bg.jpg
├── account/theme.properties             ← account console colors
└── admin/theme.properties               ← admin console colors
```

Delete the `account/` or `admin/` folders if you only want a custom login.

---

## Quickstart

1. Copy `my-brand/` to `/opt/keycloak/themes/my-brand/`. You can rename it; the folder name is the theme name.
2. Pick the variant in `login/theme.properties`: `parent=unfold-default` (centered card) or
   `parent=unfold-full` (split screen).
3. Edit the `--color-primary-*` values in `common/resources/css/my-brand.css`.
4. Drop your images into `login/resources/img/`, keeping the default file names:

   | File             | Used for                                          |
   | ---------------- | ------------------------------------------------- |
   | `logo-light.svg` | Logo in light mode (displayed 40px high)          |
   | `logo-dark.svg`  | Logo in dark mode                                 |
   | `favicon.svg`    | Browser tab icon                                  |
   | `login-bg.jpg`   | `unfold-full` hero image (portrait, ~1280px wide) |

5. In the admin console, open **Realm settings → Themes** and select `my-brand` for Login, Account and Admin.

### Other Options (`login/theme.properties`)

```properties
termsUrl=https://yoursite.com/terms      # terms link below the login form (hidden when unset)
darkMode=false                           # hide the dark mode toggle
unfoldLogoUrl=img/my-logo.svg            # other logo file names
unfoldLogoUrlDark=img/my-logo-dark.svg

# unfold-full only
bgImage=img/my-hero.jpg
kcLogoLink=https://yoursite.com          # shows the "Return to site" link
unfoldQuote=Secure. Simple. Yours.       # fixed text instead of the translatable default
unfoldQuoteSubtext=Powered by your company platform.
```

### Texts and Translations

Theme strings are message keys (`unfoldWelcomeBackTo`, `unfoldReturnToSite`, `unfoldToggleTheme`,
`unfoldTermsPrefix`, `unfoldTermsSuffix`, `unfoldQuote`, `unfoldQuoteSubtext`). To override them,
add `login/messages/messages_<lang>.properties` to your child theme, or edit them per realm under
**Realm settings → Localization → Realm overrides**.

---

## Deployment Patterns

### Docker / Docker Compose

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.8.0
    volumes:
      - ./keycloak-unfold-v0.0.1.jar:/opt/keycloak/providers/keycloak-unfold.jar:ro
      - ./my-brand:/opt/keycloak/themes/my-brand:ro
    command: start-dev
```

### Kubernetes

Mount `theme.properties` and `my-brand.css` from a `ConfigMap`. Bake binary assets (images)
into a derived image, or provide them from a volume:

```yaml
volumes:
  - name: my-brand-login
    configMap:
      name: keycloak-my-brand-login # theme.properties
  - name: my-brand-images
    persistentVolumeClaim:
      claimName: keycloak-brand-images
```

### Bare-metal / VM

```bash
cp -r my-brand /opt/keycloak/themes/
```

In production mode Keycloak caches themes, so restart it after changing theme files. In dev mode
(`start-dev`) changes show up on reload.

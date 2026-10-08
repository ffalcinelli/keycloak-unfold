# Keycloak Unfold

This repository provides a custom Keycloak theme designed to emulate the aesthetics of the [Django Unfold Theme](https://github.com/unfoldadmin/django-unfold). It focuses on a clean, modern interface by extending Keycloak's `v2` theme and overriding PatternFly 5 CSS variables.

## Project Overview

- **Architecture**: A modular Keycloak theme consisting of three variants:
  - `unfold-base`: The core theme. It holds every template, including the single shared login layout `login/template.ftl`, plus shared resources, the self-hosted Inter font and the message bundles.
  - `unfold-default`: Centered login card (`unfoldLayout=centered`, the default).
  - `unfold-full`: Split-screen login with a hero image (`unfoldLayout=split`).
- **Key Technologies**:
  - **Keycloak >= 26.8.0** (the minimum; dev and CI are pinned to 26.8.0): the target platform.
  - **Tailwind CSS v4**: utility classes in `.ftl` templates, compiled into the committed `tailwind.css`.
  - **PatternFly 5**: the underlying CSS framework, customized via variable overrides (`--pf-v5-*`).
  - **Playwright** for end-to-end tests; `node:test` + jsdom for unit tests.
  - **Docker Compose** for local development and the E2E suite.

## Development and Running

### Prerequisites

- Docker and Docker Compose
- Node.js 20+ (Maven + JDK 17 only to build the JAR)

### Common Commands

- **Start Development Environment**: `docker compose up` (port 8080; `KC_PORT=8180 docker compose up` if taken)
  - Admin: `admin` / `admin`. Demo user: `testuser` / `password`. OTP setup demo: `otpuser` / `password`.
- **Install Dependencies**: `npm install`
- **Build Tailwind CSS** (after changing classes in `.ftl` files): `npm run build:css`
- **Lint**: `npm run lint` (Stylelint, ESLint and the version sync check). **Format**: `npm run format`
- **Unit tests**: `npm run test:unit`
- **E2E tests**: `npm run test`. It starts and stops Keycloak itself. Set `KC_PORT` and `KEYCLOAK_URL` together to use another port.
- **E2E against the packaged JAR**: `mvn package && THEME_JAR=target/keycloak-unfold-v<version>.jar COMPOSE_FILE=docker-compose.jar.yml npm run test`
- **Version bump**: `npm run bump -- <x.y.z>` (keeps package.json and pom.xml in sync)

## Development Conventions

- **Theme Inheritance**: New variants extend `unfold-base` and select their login shell through theme properties, not a copied `template.ftl`.
- **Upstream parity**: `login/template.ftl` and the field macros in `login/field.ftl` mirror Keycloak's `keycloak.v2` theme. Re-check them against the upstream theme JAR when upgrading Keycloak.
- **Theme registration**: every theme type in a variant (including `common`) must be listed in `src/main/resources/META-INF/keycloak-themes.json`, or the JAR install falls back to the built-in themes.
- **CSS Variable Overrides**: core styling (colors, fonts, borders) lives in `theme/unfold-base/common/resources/css/unfold-common.css`.
- **Strings**: user-facing text goes into `theme/unfold-base/login/messages/messages_*.properties` (`unfold*` keys), never hardcoded in templates.
- **Dark Mode**: `.pf-v5-theme-dark` and `.dark` classes on `<html>`, set by `login/resources/js/theme-toggle.js`.
- **Testing**: Layout or behavior changes need updates to `tests/theme.spec.js`; dark mode script changes need updates to `tests/theme-toggle.test.js`.
- **Post-install customization**: use a child theme (see `customization/my-brand`), never a folder with the same name as a packaged theme.

## Directory Structure Highlights

- `theme/unfold-base`: Core FreeMarker templates (`.ftl`), shared CSS, fonts and messages.
- `customization/my-brand`: Example child theme for customizing an installed JAR.
- `demo/`: Realm configuration files for local testing.
- `tests/`: Playwright E2E suite and unit tests.
- `assets/`: README screenshots (`npm run screenshots`).

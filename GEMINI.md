# Keycloak Unfold Theme

This repository provides a custom Keycloak theme designed to emulate the aesthetics of the [Django Unfold Theme](https://github.com/unfoldadmin/django-unfold). It focuses on a clean, modern interface by extending Keycloak's `v2` theme and overriding PatternFly 5 CSS variables.

## Project Overview

*   **Architecture**: A modular Keycloak theme consisting of three variants:
    *   `unfold-base`: The core theme providing shared resources, variables, and common styling.
    *   `unfold-default`: A login layout with a centered container.
    *   `unfold-full`: A login layout with a split-screen background image.
*   **Key Technologies**:
    *   **Keycloak 26+**: The target platform.
    *   **Tailwind CSS**: Used for utility classes in `.ftl` templates.
    *   **PatternFly 5**: The underlying CSS framework, customized via variable overrides (`--pf-v5-*`).
    *   **Playwright**: For end-to-end and visual regression testing.
    *   **Docker**: Used for local development and demonstration.

## Development and Running

### Prerequisites
*   Docker and Docker Compose
*   Node.js (for testing and linting)

### Common Commands
*   **Start Development Environment**:
    ```bash
    docker compose up
    ```
    This starts a Keycloak instance at `http://localhost:8080` with a pre-imported `demo` realm.
    *   **Admin Credentials**: `admin` / `admin`
    *   **Demo User**: `testuser` / `password`

*   **Install Dependencies**:
    ```bash
    npm install
    ```

*   **Run Tests**:
    ```bash
    npx playwright test
    ```

*   **Lint CSS**:
    ```bash
    npm run lint:css
    ```

*   **Build Tailwind CSS (Inferred)**:
    If utility classes are modified in `.ftl` templates, use the Tailwind CLI to rebuild:
    ```bash
    npx tailwindcss -i ./theme/unfold-base/login/resources/css/tailwind-input.css -o ./theme/unfold-base/login/resources/css/tailwind.css --watch
    ```

## Development Conventions

*   **Theme Inheritance**: Always extend `unfold-base` for new variants.
*   **CSS Variable Overrides**: Core styling (colors, fonts, borders) is managed in `theme/unfold-base/common/resources/css/unfold-common.css`. Use this file to maintain a consistent look across all variants.
*   **Typography**: Uses `Inter` as the primary font family.
*   **Dark Mode**: Dark mode is supported via the `.pf-v5-theme-dark` class and corresponding CSS variable overrides.
*   **Testing**: All new features or layout changes should include updates to `tests/theme.spec.js` and, where appropriate, visual regression screenshots.
*   **Asset Management**: Place static assets like background images in the variant's `resources/img/` directory.

## Directory Structure Highlights
*   `theme/unfold-base`: Core FreeMarker templates (`.ftl`) and shared CSS.
*   `demo/`: Realm configuration files for local testing.
*   `tests/`: Playwright test suite.
*   `assets/`: Project-level documentation images.

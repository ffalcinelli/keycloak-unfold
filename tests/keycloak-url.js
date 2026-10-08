// Base URL of the Keycloak instance under test. Override when port 8080 is taken,
// together with KC_PORT for docker compose, e.g. KC_PORT=8180 KEYCLOAK_URL=http://localhost:8180
const KEYCLOAK_URL = (process.env.KEYCLOAK_URL || 'http://localhost:8080').replace(/\/+$/, '');

module.exports = { KEYCLOAK_URL };

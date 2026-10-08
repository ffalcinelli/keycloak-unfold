const { execSync } = require('child_process');
const { KEYCLOAK_URL } = require('./keycloak-url');

const DISCOVERY_URL = `${KEYCLOAK_URL}/realms/demo/.well-known/openid-configuration`;

/**
 * Returns 'keycloak' when the demo realm answers with a matching OIDC discovery document,
 * 'other' when something else is listening on the port, and 'down' when nothing answers.
 */
async function probeKeycloak() {
  let res;
  try {
    res = await fetch(DISCOVERY_URL, { signal: AbortSignal.timeout(2_000) });
  } catch {
    return 'down';
  }

  try {
    const { issuer } = await res.json();
    if (res.ok && typeof issuer === 'string' && issuer.endsWith('/realms/demo')) {
      return 'keycloak';
    }
  } catch {
    // not JSON: some other service
  }
  return 'other';
}

module.exports = async function globalSetup() {
  const state = await probeKeycloak();

  if (state === 'keycloak') {
    console.log(`Keycloak already running at ${KEYCLOAK_URL}, skipping docker compose up.`);
    process.env.KEYCLOAK_STARTED_BY_PLAYWRIGHT = '0';
    return;
  }

  if (state === 'other') {
    throw new Error(
      `${KEYCLOAK_URL} is answering but is not a Keycloak instance with the "demo" realm. ` +
        'Free the port or set KC_PORT and KEYCLOAK_URL (e.g. KC_PORT=8180 KEYCLOAK_URL=http://localhost:8180).'
    );
  }

  console.log('Starting Keycloak via docker compose...');
  // --wait blocks until the container healthcheck (/health/ready) reports healthy
  execSync('docker compose up -d --wait', { stdio: 'inherit' });
  process.env.KEYCLOAK_STARTED_BY_PLAYWRIGHT = '1';

  if ((await probeKeycloak()) !== 'keycloak') {
    throw new Error(
      `Keycloak container is healthy but ${DISCOVERY_URL} is not reachable. ` +
        'Check that KEYCLOAK_URL matches the published KC_PORT.'
    );
  }
};

const { execSync, spawn } = require('child_process');

const KEYCLOAK_URL = 'http://localhost:8080/realms/demo/account/';
const MAX_WAIT_MS = 120_000;
const POLL_INTERVAL_MS = 2_000;

async function waitForKeycloak() {
  const start = Date.now();
  process.stdout.write('Waiting for Keycloak');

  while (Date.now() - start < MAX_WAIT_MS) {
    try {
      const res = await fetch(KEYCLOAK_URL, { signal: AbortSignal.timeout(2_000) });
      if (res.ok || res.status === 401 || res.redirected) {
        process.stdout.write(' ready!\n');
        return;
      }
    } catch {
      // not ready yet
    }
    process.stdout.write('.');
    await new Promise((r) => setTimeout(r, POLL_INTERVAL_MS));
  }

  throw new Error(`Keycloak did not become ready within ${MAX_WAIT_MS / 1000}s`);
}

module.exports = async function globalSetup() {
  // Check if Keycloak is already running (e.g. the developer started it manually)
  try {
    const res = await fetch(KEYCLOAK_URL, { signal: AbortSignal.timeout(1_000) });
    if (res.ok || res.status === 401 || res.redirected) {
      console.log('Keycloak already running, skipping docker compose up.');
      process.env.KEYCLOAK_STARTED_BY_PLAYWRIGHT = '0';
      return;
    }
  } catch {
    // not running, start it
  }

  console.log('Starting Keycloak via docker compose...');
  execSync('docker compose up -d', { stdio: 'inherit' });
  process.env.KEYCLOAK_STARTED_BY_PLAYWRIGHT = '1';

  await waitForKeycloak();
};

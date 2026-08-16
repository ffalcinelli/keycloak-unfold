const { execSync } = require('child_process');

module.exports = async function globalTeardown() {
  if (process.env.KEYCLOAK_STARTED_BY_PLAYWRIGHT !== '1') {
    return;
  }

  console.log('\nStopping Keycloak via docker compose...');
  execSync('docker compose down', { stdio: 'inherit' });
};

const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');

const pkgPath = path.join(rootDir, 'package.json');
const pomPath = path.join(rootDir, 'pom.xml');

if (!fs.existsSync(pkgPath) || !fs.existsSync(pomPath)) {
  console.error('Error: Could not locate package.json or pom.xml.');
  process.exit(1);
}

const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
const pom = fs.readFileSync(pomPath, 'utf8');

// Find version in pom.xml using a regex
const pomVersionMatch = pom.match(/<version>(\d+\.\d+\.\d+)<\/version>/);
if (!pomVersionMatch) {
  console.error('Error: Could not find version in pom.xml');
  process.exit(1);
}

const pkgVersion = pkg.version;
const pomVersion = pomVersionMatch[1];

if (pkgVersion !== pomVersion) {
  console.error(`Mismatch: package.json version is "${pkgVersion}" but pom.xml version is "${pomVersion}".`);
  process.exit(1);
}

console.log(`✓ Version check passed: ${pkgVersion} (package.json) matches ${pomVersion} (pom.xml)`);

const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');

function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Get new version from command line args
const newVersion = process.argv[2];
if (!newVersion) {
  console.error('Error: Please specify a version (e.g. npm run bump -- 26.7.1)');
  process.exit(1);
}

// Regex to validate SemVer format
const semverRegex = /^\d+\.\d+\.\d+$/;
if (!semverRegex.test(newVersion)) {
  console.error(`Error: Version "${newVersion}" is not a valid SemVer (X.Y.Z)`);
  process.exit(1);
}

console.log(`Bumping project version to: ${newVersion}`);

// 1. Update package.json
const pkgPath = path.join(rootDir, 'package.json');
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
const oldVersion = pkg.version;
pkg.version = newVersion;
fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2) + '\n');
console.log('✓ Updated package.json');

// 2. Update package-lock.json
const pkgLockPath = path.join(rootDir, 'package-lock.json');
if (fs.existsSync(pkgLockPath)) {
  try {
    const pkgLock = JSON.parse(fs.readFileSync(pkgLockPath, 'utf8'));
    pkgLock.version = newVersion;
    if (pkgLock.packages && pkgLock.packages['']) {
      pkgLock.packages[''].version = newVersion;
    }
    fs.writeFileSync(pkgLockPath, JSON.stringify(pkgLock, null, 2) + '\n');
    console.log('✓ Updated package-lock.json');
  } catch (err) {
    console.error('Error updating package-lock.json:', err.message);
    process.exit(1);
  }
}

// 3. Update pom.xml
const pomPath = path.join(rootDir, 'pom.xml');
let pom = fs.readFileSync(pomPath, 'utf8');
const oldPomVersionRegex = new RegExp(`<version>${escapeRegExp(oldVersion)}</version>`);
if (oldPomVersionRegex.test(pom)) {
  pom = pom.replace(oldPomVersionRegex, `<version>${newVersion}</version>`);
  fs.writeFileSync(pomPath, pom);
  console.log('✓ Updated pom.xml');
} else {
  console.warn('Warning: Could not find matching old version in pom.xml to replace.');
}

// 4. Update docker-compose.yml (Keycloak image version)
const dockerComposePath = path.join(rootDir, 'docker-compose.yml');
if (fs.existsSync(dockerComposePath)) {
  let dockerCompose = fs.readFileSync(dockerComposePath, 'utf8');
  const oldImageRegex = new RegExp(`image: quay.io/keycloak/keycloak:${escapeRegExp(oldVersion)}`);
  if (oldImageRegex.test(dockerCompose)) {
    dockerCompose = dockerCompose.replace(oldImageRegex, `image: quay.io/keycloak/keycloak:${newVersion}`);
    fs.writeFileSync(dockerComposePath, dockerCompose);
    console.log('✓ Updated docker-compose.yml');
  } else {
    // If not matching exact version, fallback to replacing the general tag
    dockerCompose = dockerCompose.replace(/image: quay.io\/keycloak\/keycloak:\d+\.\d+\.\d+/, `image: quay.io/keycloak/keycloak:${newVersion}`);
    fs.writeFileSync(dockerComposePath, dockerCompose);
    console.log('✓ Updated docker-compose.yml (fallback replace)');
  }
}

// 5. Update README.md
const readmePath = path.join(rootDir, 'README.md');
if (fs.existsSync(readmePath)) {
  let readme = fs.readFileSync(readmePath, 'utf8');
  // Replace tested version
  readme = readme.replace(new RegExp(`Tested and verified against \`v${escapeRegExp(oldVersion)}\``, 'g'), `Tested and verified against \`v${newVersion}\``);
  // Replace JAR filenames
  readme = readme.replace(new RegExp(`keycloak-unfold-v${escapeRegExp(oldVersion)}\\.jar`, 'g'), `keycloak-unfold-v${newVersion}.jar`);
  fs.writeFileSync(readmePath, readme);
  console.log('✓ Updated README.md');
}

// 6. Update docs/index.html
const docsIndexPath = path.join(rootDir, 'docs', 'index.html');
if (fs.existsSync(docsIndexPath)) {
  let docsIndex = fs.readFileSync(docsIndexPath, 'utf8');
  docsIndex = docsIndex.replace(new RegExp(`keycloak-unfold-v${escapeRegExp(oldVersion)}\\.jar`, 'g'), `keycloak-unfold-v${newVersion}.jar`);
  fs.writeFileSync(docsIndexPath, docsIndex);
  console.log('✓ Updated docs/index.html');
}

console.log('Version bump complete successfully!');

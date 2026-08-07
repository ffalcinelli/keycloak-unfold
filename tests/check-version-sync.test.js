const test = require('node:test');
const assert = require('node:assert');
const child_process = require('child_process');
const util = require('util');
const path = require('path');
const fs = require('fs');
const os = require('os');

const exec = util.promisify(child_process.exec);

test('fails when package.json or pom.xml is missing', async () => {
    const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'version-sync-test-'));
    try {
        const scriptDir = path.join(tempDir, 'scripts');
        fs.mkdirSync(scriptDir);

        const scriptPath = path.join(__dirname, '../scripts/check-version-sync.js');
        const tempScriptPath = path.join(scriptDir, 'check-version-sync.js');
        fs.copyFileSync(scriptPath, tempScriptPath);

        let error;
        try {
            await exec(`node ${tempScriptPath}`);
        } catch (e) {
            error = e;
        }

        assert.ok(error, 'Should exit with an error');
        assert.strictEqual(error.code, 1, 'Should have exit code 1');
        assert.ok(error.stderr.includes('Error: Could not locate package.json or pom.xml.'), 'Should print correct error message');
    } finally {
        fs.rmSync(tempDir, { recursive: true, force: true });
    }
});

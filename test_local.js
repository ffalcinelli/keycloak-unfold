const { chromium } = require('playwright');
const fs = require('fs');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  const content = await fs.promises.readFile('theme/unfold-default/login/template.ftl', 'utf8');
  console.log(content.substring(0, 500));
  await browser.close();
})();

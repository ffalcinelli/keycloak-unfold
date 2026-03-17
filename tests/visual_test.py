import asyncio
from playwright.async_api import async_playwright
import os
import subprocess
import time
import urllib.request
import sys

async def main():
    # Start a simple HTTP server
    server_process = subprocess.Popen([sys.executable, "-m", "http.server", "8081"])

    # Wait for server to start
    for _ in range(10):
        try:
            urllib.request.urlopen("http://localhost:8081")
            break
        except Exception:
            time.sleep(0.5)

    try:
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page()

            html_content = """
            <!DOCTYPE html>
            <html>
            <head>
                <link rel="stylesheet" href="/theme/unfold/common/resources/css/unfold-common.css">
                <link rel="stylesheet" href="/theme/unfold/login/resources/css/tailwind.css">
            </head>
            <body class="bg-base-50 antialiased font-sans">
                <div id="page" class="bg-white flex min-h-screen">
                    <div class="flex flex-1 items-center justify-center p-8">
                        <button id="primary-btn" class="pf-v5-c-button pf-m-primary bg-primary-600 rounded-md p-2 text-white">Primary Button</button>
                    </div>
                </div>
            </body>
            </html>
            """

            os.makedirs("tests/visual", exist_ok=True)
            with open("tests/visual/test.html", "w") as f:
                f.write(html_content)

            await page.goto("http://localhost:8081/tests/visual/test.html")

            # Wait a bit for CSS to load
            await page.wait_for_timeout(1000)

            # Test visual style
            btn = page.locator("#primary-btn")
            bg_color = await btn.evaluate("el => window.getComputedStyle(el).backgroundColor")
            print(f"Background color: {bg_color}")

            body = page.locator("body")
            body_bg_color = await body.evaluate("el => window.getComputedStyle(el).backgroundColor")
            print(f"Body background color: {body_bg_color}")

            # Check the primary-600 color
            assert "rgb(124, 58, 237)" in bg_color or "oklch(0.558 0.288 302.321)" in bg_color, f"Unexpected background color {bg_color}"

            # Check base-50 color for body
            assert "rgb(248, 250, 252)" in body_bg_color or "oklch(0.985 0.002 247.839)" in body_bg_color, f"Unexpected body background color {body_bg_color}"

            print("Visual test passed")

            await browser.close()
    finally:
        server_process.terminate()
        server_process.wait()

if __name__ == "__main__":
    asyncio.run(main())

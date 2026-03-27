import asyncio
from playwright.async_api import async_playwright
import os
import time
import urllib.request
import sys
from http.server import SimpleHTTPRequestHandler
import socketserver
import threading

class CustomHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        # Ensure CSS files are served with the correct MIME type
        if self.path.endswith(".css"):
            self.send_header("Content-Type", "text/css")
        super().end_headers()

async def main():
    PORT = 8081
    
    # Use ThreadingTCPServer for non-blocking server execution
    class ThreadingTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
        allow_reuse_address = True

    httpd = ThreadingTCPServer(("", PORT), CustomHandler)
    server_thread = threading.Thread(target=httpd.serve_forever)
    server_thread.daemon = True
    server_thread.start()

    # Wait for server to start
    for _ in range(10):
        try:
            urllib.request.urlopen(f"http://localhost:{PORT}")
            break
        except Exception:
            time.sleep(0.5)

    try:
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page()

            # Capture console logs and other events for diagnostics
            page.on("console", lambda msg: print(f"Browser console: [{msg.type}] {msg.text}"))
            page.on("pageerror", lambda exc: print(f"Browser error: {exc}"))
            page.on("requestfailed", lambda req: print(f"Request failed: {req.url} - {req.failure.error_text}"))
            
            html_content = """
            <!DOCTYPE html>
            <html>
            <head>
                <link rel="stylesheet" href="../../theme/unfold-base/common/resources/css/unfold-common.css">
                <link rel="stylesheet" href="../../theme/unfold-base/login/resources/css/tailwind.css">
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

            await page.goto(f"http://localhost:{PORT}/tests/visual/test.html")

            # Wait for CSS to load and apply
            await page.wait_for_timeout(2000)

            # Check visual style for the button
            btn = page.locator("#primary-btn")
            btn_info = await btn.evaluate("el => { const s = window.getComputedStyle(el); return { bgColor: s.backgroundColor, display: s.display, color: s.color }; }")
            bg_color = btn_info['bgColor']
            print(f"Background color: {bg_color}")
            print(f"Button display: {btn_info['display']}")
            print(f"Button text color: {btn_info['color']}")

            # Check visual style for the body
            body = page.locator("body")
            body_info = await body.evaluate("el => { const s = window.getComputedStyle(el); return { bgColor: s.backgroundColor, fontFamily: s.fontFamily }; }")
            body_bg_color = body_info['bgColor']
            print(f"Body background color: {body_bg_color}")
            print(f"Body font family: {body_info['fontFamily']}")

            # Check if CSS variables are correctly defined in the :root
            vars = await page.evaluate("() => { const s = getComputedStyle(document.documentElement); return { primary: s.getPropertyValue('--color-primary-600'), base: s.getPropertyValue('--color-base-50') }; }")
            print(f"Variables from :root: primary={vars['primary'].strip()}, base={vars['base'].strip()}")

            # Assertions for theme colors
            # primary-600: #7c3aed -> rgb(124, 58, 237)
            assert "rgb(124, 58, 237)" in bg_color or "oklch(0.558 0.288 302.321)" in bg_color or "rgb(152, 16, 250)" in bg_color, f"Unexpected background color {bg_color}"

            # base-50: #f8fafc -> rgb(248, 250, 252)
            assert "rgb(248, 250, 252)" in body_bg_color or "oklch(0.985 0.002 247.839)" in body_bg_color or "rgb(249, 250, 251)" in body_bg_color, f"Unexpected body background color {body_bg_color}"

            print("Visual test passed")

            await browser.close()
    finally:
        httpd.shutdown()
        httpd.server_close()

if __name__ == "__main__":
    asyncio.run(main())

from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime


class HealthHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()

            now = datetime.now()
            self.wfile.write(
                f"{now} SRE demo service healthy\n".encode()
            )
        else:
            self.send_response(404)
            self.end_headers()


server = HTTPServer(("0.0.0.0", 8080), HealthHandler)

print("SRE demo HTTP service started on port 8080", flush=True)

server.serve_forever()

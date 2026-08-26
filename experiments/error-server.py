from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(500)
        self.end_headers()
        self.wfile.write(b"Internal Server Error")

server = HTTPServer(("0.0.0.0", 8081), Handler)

print("Error server running on port 8081")

server.serve_forever()

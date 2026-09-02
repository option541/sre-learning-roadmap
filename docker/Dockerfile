FROM python:3.14-slim

WORKDIR /app

COPY app.py .

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')"

CMD ["python3", "app.py"]

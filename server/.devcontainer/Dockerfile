// filepath: /workspaces/IOT_Project/server/Dockerfile
FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
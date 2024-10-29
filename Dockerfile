FROM python:3.10-slim

ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin/ && \
    rm ngrok-stable-linux-amd64.zip

WORKDIR /code

COPY ./req.txt .
RUN pip install -r req.txt

# Устанавливаем пакет для работы с .env (например, python-dotenv)
RUN pip install python-dotenv

COPY . .

# Авторизация ngrok с использованием вашего токена
# Загружаем переменные окружения из .env файла
RUN export $(cat .env | xargs) && \
    ngrok config add-authtoken $NGROK_AUTHTOKEN


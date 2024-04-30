FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y nodejs npm \
    && mkdir /app \
    && npm install -g serve

COPY build/* /app

EXPOSE 80

CMD serve -s /app
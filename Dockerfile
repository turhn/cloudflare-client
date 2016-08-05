FROM ruby:2.3.1

RUN mkdir -p /opt/cloudflare
WORKDIR /opt/cloudflare
ADD . /opt/cloudflare

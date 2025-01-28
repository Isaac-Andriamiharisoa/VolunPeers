# syntax = docker/dockerfile:1
FROM ruby:3.1.2

RUN apt update && \
    apt install -y --no-install-recommends \
    postgresql-client \
    build-essential \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    yarn \
    libffi-dev \
    libreadline-dev \
    libpq-dev \
    libc-dev \
    linux-headers-generic \
    file \
    imagemagick \
    git \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json yarn.lock ./

COPY . .

ENV BUNDLE_PATH /gems
RUN gem install bundler
RUN bundle install

ENTRYPOINT [ "bin/rails" ]
CMD [ "s", "-b", "0.0.0.0" ]

EXPOSE 3000
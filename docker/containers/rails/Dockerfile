FROM ruby:2.4.1
ENV APP_ROOT /app/rails

RUN apt-get update &&\
  apt-get install -y \
    cmake \
    nodejs \
    mysql-client \
    libicu-dev \
    --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/
COPY ./Gemfile.lock $APP_ROOT/
COPY config/database.example.yml $APP_ROOT/config/database.yml

RUN \
  bundle config --local without test development doc && \
  bundle install --path vendor/bundle -j4 ${BUNDLE_OPTION}

ADD . $APP_ROOT/
RUN rm -rf ${APP_ROOT}/docker


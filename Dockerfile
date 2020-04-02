# BUILD DEPENDENCIES
FROM ruby:2.6-alpine AS build

WORKDIR /coyote

ENV RAILS_ENV production
ENV RACK_ENV ${RAILS_ENV}
ENV NODE_ENV ${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT 1
ENV RAILS_ROOT /coyote
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache \
  build-base \
  git \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  postgresql-client \
  postgresql-dev \
  ruby-json \
  tzdata \
  yaml-dev

# Install (and clean) Gem dependencies
RUN gem install bundler:2.1.4
ADD Gemfile* ./
RUN bundle config --global frozen 1 \
  && bundle config set path "vendor/bundle" \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install -j4 --retry 3 --path=vendor/bundle \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

ADD . /coyote

# Remove unused folders
# RUN rm -rf app/assetslog/* node_modules tmp/cache vendor/assets spec

# RUN THE APP
FROM ruby:2.6-alpine

WORKDIR /coyote

ENV RAILS_ENV production
ENV RACK_ENV ${RAILS_ENV}
ENV NODE_ENV ${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT 1
ENV RAILS_ROOT /coyote
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache \
  libxml2 \
  libxslt \
  nodejs \
  postgresql-client \
  tzdata

COPY --from=build $RAILS_ROOT $RAILS_ROOT

EXPOSE 3000

CMD [ "bundle", "exec", "puma", "-c", "config/puma.rb" ]

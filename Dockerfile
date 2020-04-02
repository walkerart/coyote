FROM ruby:2.6-alpine

WORKDIR /coyote

ARG bundle_without="development test"

ENV RAILS_ENV production
ENV RACK_ENV ${RAILS_ENV}
ENV NODE_ENV ${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT 1
ENV RAILS_ROOT /coyote
# ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

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
RUN gem install bundler:2.1.4 --no-document --conservative
ADD Gemfile* ./
RUN bundle config --global frozen 1 \
  # && bundle config set path "vendor/bundle" \
  && bundle config set without "${bundle_without}" \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install --jobs=4 --retry=3 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the remainder and launch the app
ADD . /coyote
EXPOSE 3000
CMD [ "./bin/release" ]

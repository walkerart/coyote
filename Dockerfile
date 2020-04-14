FROM ruby:2.5.1
MAINTAINER Mike Subelsky <mike@subelsky.com>
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs software-properties-common

RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main"
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-9.6
RUN apt-get install -y coreutils
RUN apt-get install -y default-libmysqlclient-dev
#                      (instead of libmysqlclient-dev)

ADD . /coyote
WORKDIR /coyote

RUN gem install bundler -v 1.16.6

RUN bundler -v; gem list | grep bundler
RUN bundle config

RUN gem install nokogiri -v '1.10.9' --source 'https://rubygems.org/'
RUN gem install unf_ext -v 0.0.7.6
RUN gem install sassc -v 2.2.1
RUN gem install bcrypt -v 3.1.13

RUN which bundler
RUN gem list
RUN bundle install


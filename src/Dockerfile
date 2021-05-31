FROM ruby:3.0.1

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs postgresql-client

RUN mkdir /app
WORKDIR /app

ENV BUNDLER_VERSION=2.2.15
RUN gem install bundler -v 2.2.15

COPY dokumentvwsys/Gemfile dokumentvwsys/Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

ADD . /app

WORKDIR /app/dokumentvwsys

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE 3000

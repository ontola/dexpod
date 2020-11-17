FROM ruby:2.7.0-alpine

RUN apk --update --no-cache add curl openssh-client postgresql-dev libffi-dev libxml2-dev libxslt-dev libwebp-dev

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/

RUN apk --update --no-cache add git build-base pkgconfig\
    && RAILS_ENV=production bundle install --deployment --frozen --clean --without development test --path vendor/bundle\
    && apk del git pkgconfig build-base

COPY . /usr/src/app

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

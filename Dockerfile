# Dockerfile.rails
FROM ruby:3.1.2

WORKDIR /usr/src/app

RUN apt-get update -yqq
RUN apt-get install -yqq - no-install-recommends nodejs

RUN git config - global user.name "adonis0907" && \
    git config - global user.email "adonis0907@outlook.com"

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config - global frozen 1
# COPY Gemfile gemfile.lock ./
# RUN bundle install

# COPY . .
# CMD ["/your-daemon-or-script.rb"]

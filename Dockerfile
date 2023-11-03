FROM ruby:3.2.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock worker.rb ./
RUN bundle install

CMD ruby ./worker.rb
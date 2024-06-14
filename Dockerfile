FROM ruby:3.1.2
RUN apt-get update
WORKDIR /app
RUN gem install bundler
COPY Gemfile* .
RUN bundle install
COPY . /app
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
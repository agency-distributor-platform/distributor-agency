FROM ruby:3.1.1
RUN apt-get update
RUN mkdir /root/src
WORKDIR /root/src
RUN gem install bundler
COPY Gemfile* .
RUN bundle install
COPY . /root/src
EXPOSE 3000
FROM ruby:3.1.1-alpine

# Install build tools and other dependencies
RUN apk update && \
    apk add --no-cache build-base

# Create and set the working directory
RUN mkdir /root/src
WORKDIR /root/src

# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile* . 

# Install gem dependencies
RUN bundle install

# Copy the rest of the application code
COPY . /root/src

# Expose port 3000
EXPOSE 3000


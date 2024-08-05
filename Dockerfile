FROM ruby:3.1.1
RUN apt-get update && \
    apt-get install -y python3 python3-pip mariadb-client
RUN pip install python-docx
RUN mkdir /root/src
WORKDIR /root/src
RUN gem install bundler
COPY Gemfile* .
RUN bundle install
COPY . /root/src
EXPOSE 3000
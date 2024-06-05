FROM ruby:2.5.9
RUN apt-get update && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile ./
# RUN bundle install
# COPY . .
# EXPOSE 3000
# CMD ["rails", "server", "-b", "0.0.0.0"]


#mysql8 image 
# cmd : docker pull mysql:8.0
#mysql8 container 
# cmd : docker run --name mysql8-test -e MYSQL_ROOT_PASSWORD=root -d mysql:8.0
# give container and password as per your choice

#Docker build image
#cmd : docker build -t distributor-agency .
# give image name of your choice
# docker build container 
#cmd : #docker run -p 4000:4000 --name agency  -v $(pwd):/distributor-agency --link mysql8-test -d -it distributor-agency
# give container name, port as per your choice




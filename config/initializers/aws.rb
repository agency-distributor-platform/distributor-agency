# config/initializers/aws.rb

Aws.config.update({
  region: 'us-east-1', # replace with your preferred region
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

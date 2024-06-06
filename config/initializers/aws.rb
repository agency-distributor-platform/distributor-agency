# config/initializers/aws.rb

Aws.config.update({
  region: 'us-east-1', # replace with your preferred region
  # credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  credentials: Aws::Credentials.new("AKIA26WHCW34DVI3NLNV", "GDVR0f6MRRLDbY4WsPpaC7iox6I2k1a7/z3DZ6Y4")
})

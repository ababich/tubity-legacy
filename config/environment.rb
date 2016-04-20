# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tubity::Application.initialize!

#RestClient config
#RestClient.log = Rails.logger
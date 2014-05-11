# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Timetracker::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
   :enable_starttls_auto => true,
   :address => "smtp.mailgun.org",
   :port => 587,
   :domain => "brainbox.mailgun.org",
   :authentication => :plain,
   :user_name => "postmaster@brainbox.com",
   :password => "23fuh0hvxtb3"
}


# ActionMailer::Base.smtp_settings = {
#    :enable_starttls_auto => true,
#    :address => "smtp.gmail.com",
#    :port => 587,
#    :domain => "gmail.com",
#    :authentication => :plain,
#    :user_name => "brainbox.amra@gmail.com",
#    :password => "amra1234"
# }

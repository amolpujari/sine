git clone git@github.com:amolpujari/saw.git
cd sine
rvm use ruby-2.3.0@sine
bundle
bundle exec rake db:setup
rails s

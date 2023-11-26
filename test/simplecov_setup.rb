# test/simplecov_setup.rb
if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start :rails do
    # add_group 'Models', 'app/models/'
    # add_group 'Controllers', 'app/controllers/'
    # add_group 'Services', 'app/services/'
    add_filter 'vendor'
  end
end

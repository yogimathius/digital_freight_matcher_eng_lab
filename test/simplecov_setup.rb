# test/simplecov_setup.rb
if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start :rails do
    add_filter 'vendor'
    add_filter 'app/channels'
    add_filter 'app/jobs'
    add_filter 'app/mailers'

    SimpleCov.branch_coverage?

    enable_coverage(:branch)
    enable_coverage(:line)
    enable_coverage_for_eval
  end

  parallel_number = [
    ENV['CIRCLE_NODE_INDEX'] || ENV.fetch('CI_INDEX', nil),
    ENV['TEST_ENV_NUMBER'] || ENV.fetch('JOB_NUMBER', nil)
  ].compact.join('_')

  if parallel_number.present?
    SimpleCov.command_name "Job #{parallel_number}"
  end
end

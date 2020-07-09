# frozen_string_literal: true

set :environment, ENV['RAILS_ENV'] ||= 'development'
set :output, File.join('log', 'cron.log')
ENV.each { |k, v| env(k, v) }

every '0 0 * * *' do
  runner 'Rails.configuration.refcache.clean'
end

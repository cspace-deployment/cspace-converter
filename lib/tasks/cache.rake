namespace :cache do
  # bundle exec rake cache:download
  task :download => :environment do |t, args|
    cache_service = CacheService.new
    cache_service.download
  end

  # bundle exec rake cache:refresh
  task :refresh => :environment do
    cache_service = CacheService.new
    cache_service.refresh
  end
end

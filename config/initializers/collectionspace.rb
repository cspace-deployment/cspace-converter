# frozen_string_literal: true

# Require the DEFAULT and EXTENSION modules
%w[default extension].each do |base|
  Dir[
    "#{Rails.root.join('lib', 'collectionspace', 'converter', base)}/*.rb"
  ].sort.each do |lib|
    require lib
  end
end

# Require everything else (starting with "_*")
Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].sort.each do |lib|
  require lib
end

cache_service = CacheService.new
cache_service.import if File.file?(cache_service.cache_file)

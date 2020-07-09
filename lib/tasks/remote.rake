namespace :remote do
  namespace :batch do
    task :delete, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "delete", type, batch
    end

    task :transfer, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "transfer", type, batch
    end

    task :update, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "update", type, batch
    end

    def remote_action_process(action, type, batch)
      start_time = Time.now
      Rails.logger.debug "Starting remote #{action} job at #{start_time}."
      key = SecureRandom.uuid
      Batch.create(
        key: key,
        category: 'transfer',
        type: action,
        for: type,
        name: batch,
        start: Time.now,
        total: CollectionSpaceObject.where(type: type, batch: batch).count
      )

      TransferJob.perform_now(action, type, batch, key)
      end_time = Time.now
      Rails.logger.debug "Remote #{action} job completed at #{end_time}."
    end
  end

  namespace :client do
    # bundle exec rake remote:client:all[acquisitions]
    task :all, [:path] => :environment do |t, args|
      path = args[:path]
      Rails.configuration.client.all(path).each { |item| puts item }
    end

    # bundle exec rake remote:client:get[acquisitions]
    task :get, [:path] => :environment do |t, args|
      path = args[:path]
      puts Rails.configuration.client.get(path).xml
    end
  end

  namespace :service do
    # bundle exec rake remote:service:delete[CollectionObject,ABC.123]
    task :delete, [:type, :identifier] => :environment do |t, args|
      request(args.fetch(:type), args.fetch(:identifier), :delete)
    end

    # bundle exec rake remote:service:ping[CollectionObject,ABC.123]
    task :ping, [:type, :identifier] => :environment do |t, args|
      request(args.fetch(:type), args.fetch(:identifier), :ping)
    end

    # bundle exec rake remote:service:search[2020.1.1,CollectionObject]
    # bundle exec rake remote:service:search[AcidLithographic1986516377,Concept,nomenclature]
    task :search, [:identifier, :type, :subtype] => :environment do |t, args|
      service = Lookup.record_class(args.fetch(:type)).service(args.fetch(:subtype, nil))
      puts RemoteActionService.perform_search_request(
        service: service,
        value: args.fetch(:identifier)
      ).xml
    end

    # bundle exec rake remote:service:transfer[CollectionObject,ABC.123]
    task :transfer, [:type, :identifier] => :environment do |t, args|
      request(args.fetch(:type), args.fetch(:identifier), :transfer)
    end

    # bundle exec rake remote:service:update[CollectionObject,ABC.123]
    task :update, [:type, :identifier] => :environment do |t, args|
      request(args.fetch(:type), args.fetch(:identifier), :update)
    end

    def request(type, identifier, action)
      obj = CollectionSpaceObject.where(
        type: type,
        identifier: identifier
      ).first
      abort("CollectionSpaceObject not found for identifier: #{identifier}") unless obj

      status = RemoteActionService.new(obj).send(action)
      obj.transfer_statuses.create(
        transfer_status: status.success?,
        transfer_message: status.message
      )
    end
  end
end

namespace :db do
  namespace :export do
    # rake db:export:xml
    task :xml => :environment do |t|
      # mongoid batches by default
      base = ['db', 'data', 'export']
      CollectionSpaceObject.all.each do |obj|
        path = Rails.root.join(File.join(base + [obj.category, obj.type, obj.subtype].compact))
        FileUtils.mkdir_p File.join(path)
        file_path = path + "#{obj.identifier}.xml"
        Rails.logger.debug "Exporting: #{file_path}"
        File.open(file_path, 'w') {|f| f.write(obj.content) }
      end
    end
  end

  namespace :import do
    def process(job_class, config)
      Rake::Task['cache:setup'].invoke
      counter = 1
      # process in chunks of 100 rows
      SmarterCSV.process(config[:filename], {
          chunk_size: 100,
          convert_values_to_numeric: false,
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        Rails.logger.debug "Processing #{config[:batch]} #{counter}"
        job_class.perform_later(config, chunk)
        # run the job immediately when using rake
        Delayed::Worker.new.run(Delayed::Job.last)
        counter += 1
      end
    end

    # rake db:import:data[data/sample/SampleCatalogingData.csv,cataloging1,Core,cataloging]
    task :data, [:filename, :batch, :module, :profile, :use_auth_cache_file] => :environment do |t, args|
      config = {
        filename:  args[:filename],
        batch:     args[:batch],
        module:    args[:module],
        profile:   args[:profile],
      }
      unless File.file? config[:filename]
        Rails.logger.error "Invalid file #{config[:filename]}"
        abort
      end
      Rails.logger.debug "Project #{config[:module]}; Batch #{config[:batch]}; Profile #{config[:profile]}"
      process ImportProcedureJob, config
      Rails.logger.debug "Data import complete!"
    end

    # rake db:import:authorities[data/sample/SamplePerson.csv,person1,Core,name,Person]
    # rake db:import:authorities[data/sample/SampleMaterial.csv,materials1,Core,materials,Concept,materials_ca]
    task :authorities, [:filename, :batch, :module, :id_field, :type, :subtype, :use_auth_cache_file] => :environment do |t, args|
      config = {
        filename:   args[:filename],
        batch:      args[:batch],
        module:     args[:module],
        id_field:   args[:id_field],
        type:       args[:type],
        subtype:    args[:subtype] ||= args[:type].downcase,
      }
      unless File.file? config[:filename]
        Rails.logger.error "Invalid file #{config[:filename]}"
        abort
      end
      Rails.logger.debug "Project #{config[:module]}; Batch #{config[:batch]}"
      process ImportAuthorityJob, config
      Rails.logger.debug "Data import complete!"
    end
  end

  # rake db:nuke
  task :nuke => :environment do |t|
    CollectionSpace::Converter::Nuke.everything!
    Rails.logger.debug "Database nuked!"
  end
end

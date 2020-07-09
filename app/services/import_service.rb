class ImportService
  class Base
    attr_reader :config, :data, :object
    def initialize(data)
      @data    = data
      @object  = nil
      # profile config
      @config = Lookup.profile_config(@data[:converter_profile])
    end

    def add_authority(name_field:, type:, subtype:, mapper: nil)
      display_name = object.csv_data[name_field]
      return unless display_name

      service = Lookup.record_class(type).service(subtype)[:id]
      names_for(display_name).each do |name|
        stub = mapper.nil? ? true : false
        id = identifier_for(:authority, service, subtype, name, stub)
        next if id.nil?

        object.add_authority(
          type: type,
          subtype: subtype,
          name: name,
          identifier: id,
          mapper: mapper
        )
        object.save!
      end
    end

    def add_related_authorities(authorities)
      authorities.each do |attributes|
        name_field, type, subtype = gather_authority_data(attributes)
        next unless type

        add_authority(
          name_field: name_field,
          type: type,
          subtype: subtype,
          mapper: nil
        )
      end
    end

    def add_related_vocabularies(vocabularies)
      vocabularies.each do |attributes|
        add_vocabulary(
          name_field: attributes['name_field'],
          subtype: attributes['vocabulary_subtype'],
          stub: true
        )
      end
    end

    def add_vocabulary(name_field:, subtype:, stub: false)
      display_name = object.csv_data[name_field]
      return unless display_name

      names_for(display_name).each do |name|
        id = identifier_for(:vocabulary, 'vocabularies', subtype, name, stub)
        next if id.nil?

        object.add_vocabulary(
          type: 'Vocabulary',
          subtype: subtype,
          name: name,
          identifier: id,
          stub: stub
        )
        object.save!
      end
    end

    def create_object
      @object = DataObject.new.from_json(JSON.generate(data))
      @object.save!
    end

    def gather_authority_data(attributes)
      name_field = attributes['name_field']

      if attributes['authority_type_from']
        type = object.csv_data[attributes['authority_type_from']]
      end
      type ||= attributes['authority_type']
      type = type.capitalize if type

      subtype = attributes['authority_subtype'] ||= type.downcase
      [name_field, type, subtype]
    end

    def identifier_for(method, type, subtype, name, stub)
      identifier = if method == :authority
        AuthCache.authority(type, subtype, name)
      elsif method == :vocabulary
        AuthCache.vocabulary(subtype, name)
      end
      # we don't want to create a stub record when identifier is found
      return nil if identifier && stub

      identifier = object.csv_data.fetch('shortidentifier', identifier)
      identifier || CSIDF.short_identifier(name)
    end

    def names_for(display_name)
      display_name.split(object.delimiter).map(&:strip).reject{ |e| e.empty? }
    end

    def process
      raise 'Error: must be implemented in subclass'
    end

    def update_status(import_status:, import_message:)
      raise 'Data Object has not been created' unless object

      object.write_attributes(
        import_status: import_status,
        import_message: import_message
      )
      object.save!
    end
  end

  class Authorities < Base
    def process
      raise 'Data Object has not been created' unless object

      add_authority(
        mapper: config['mapper'],
        name_field: config['name_field'],
        type: config['authority_type'],
        subtype: config['authority_subtype']
      )
      add_related_authorities(config.fetch('Authorities', {}))
      add_related_vocabularies(config.fetch('Vocabularies', {}))
    end
  end

  class Hierarchies < Base
    def process
      raise 'Data Object has not been created' unless object

      object.add_hierarchy
    end
  end

  class Procedures < Base
    def process
      raise 'Data Object has not been created' unless object

      config.each do |procedure, attributes|
        next if ['Authorities', 'Vocabularies'].include?(procedure)

        object.add_procedure procedure, attributes
        object.save!
      end
      add_related_authorities(config.fetch('Authorities', {}))
      add_related_vocabularies(config.fetch('Vocabularies', {}))
    end
  end

  class Relationships < Base
    def process
      raise 'Data Object has not been created' unless object

      object.add_relationship
    end
  end

  class Vocabularies < Base
    def process
      raise 'Data Object has not been created' unless object

      add_vocabulary(
        name_field: config['name_field'],
        subtype: config['vocabulary_subtype']
      )
    end
  end
end

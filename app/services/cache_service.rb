# frozen_string_literal: true

class CacheService
  attr_reader :cache, :client, :items
  def initialize
    @cache = Rails.configuration.refcache
    @client = Rails.configuration.client
    @items = []
    FileUtils.mkdir_p cache_dir
  end

  def authorities
    Lookup.module.registered_authorities
  end

  def cache_dir
    File.join(ENV['HOME'], '.cspace-converter')
  end

  def cache_file
    File.join(cache_dir, "#{ENV.fetch('CSPACE_CONVERTER_DB_NAME')}_#{Rails.env}.csv")
  end

  def csv_headers
    %w[
      type
      subtype
      term
      refname
    ]
  end

  def download
    process(['vocabularies'])
    process(authorities)
    export
  end

  def import
    unless File.file? cache_file
      Rails.logger.info "Cache not found: #{cache_file}"
      return
    end

    Rails.logger.info "Loading cache: #{cache_file}"
    SmarterCSV.process(File.open(cache_file, 'r:bom|utf-8'), {
      chunk_size: 100,
      convert_values_to_numeric: true,
      required_headers: csv_headers.map(&:to_sym)
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      chunk.each do |item|
        cache.put(
          item[:type], item[:subtype], item[:term], item[:refname]
        )
      end
    end
  end

  def refresh
    download
    import
  end

  private

  def export
    FileUtils.rm_rf cache_file if File.file? cache_file

    Rails.logger.info "Exporting cache: #{cache_file}"
    headers = csv_headers
    CSV.open(cache_file, 'a') do |csv|
      csv << headers
    end

    items.each do |item|
      CSV.open(cache_file, 'a') do |csv|
        csv << item.values_at(*headers)
      end
    end
  end

  def process(endpoints)
    endpoints.each do |endpoint|
      Rails.logger.debug "Processing endpoint: #{endpoint}"
      client.all(endpoint).each do |list|
        client.all("#{list['uri']}/items").each do |item|
          refname = item['refName']
          next unless refname

          Rails.logger.debug "Processing item: #{refname}"
          parsed = CSURN.parse(refname)
          items << {
            'type' => parsed[:type],
            'subtype' => parsed[:subtype],
            'term' => parsed[:label],
            'refname' => refname
          }
        end
      end
    end
  end
end

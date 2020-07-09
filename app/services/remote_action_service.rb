require 'uri'

class RemoteActionService
  attr_reader :client, :object, :service

  class Status
    attr_accessor :success, :message
    def initialize(success: false, message: '')
      @success = success
      @message = message
    end

    def bad(message)
      @success = false
      @message = message
      Rails.logger.error(message)
    end

    def good(message)
      @success = true
      @message = message
      Rails.logger.debug(message)
    end

    def success?
      @success
    end
  end

  def initialize(object)
    @client  = Rails.configuration.client
    @object  = object
    @service = Lookup.record_class(object.type).service(object.subtype)
  end

  def for_relationship?
    object.category == 'Relationship' && service[:path] = 'relations'
  end

  def list_criteria
    if for_relationship?
      ['relations_common_list', 'relation_list_item']
    else
      ['abstract_common_list', 'list_item']
    end
  end

  def perform_search_request
    if for_relationship?
      RemoteActionService.perform_relations_request(
        subject_csid: object.subject_csid,
        object_csid: object.object_csid
      )
    else
      RemoteActionService.perform_search_request(
        service: service,
        value: object.identifier
      )
    end
  end

  def delete
    status = Status.new
    if object.has_csid_and_uri?
      Rails.logger.debug("Deleting: #{object.identifier}")
      begin
        response = client.delete(object.uri)
        if response.result.success?
          object.update_attributes!(csid: nil, uri:  nil)
          status.good "Deleted: #{object.identifier}"
        else
          status.bad "Error response: #{response.result.body}"
        end
      rescue StandardError => err
        status.bad "Error during delete: #{err.message}"
      end
    else
      status.bad "Delete requires existing csid and uri."
    end
    status
  end

  def transfer
    status = Status.new
    unless object.has_csid_and_uri?
      Rails.logger.debug("Transferring: #{object.identifier}")
      begin
        blob_uri = object.data_object.csv_data.fetch('bloburi', nil)
        blob_uri = URI.encode blob_uri if !blob_uri.blank?
        params   = (blob_uri && object.type == 'Media') ? { query: { 'blobUri' => blob_uri } } : {}
        response = client.post(service[:path], object.content, params)
        if response.result.success?
          # http://localhost:1980/cspace-services/collectionobjects/7e5abd18-5aec-4b7f-a10c
          csid = response.result.headers['Location'].split('/')[-1]
          uri  = "#{service[:path]}/#{csid}"
          object.update_attributes!(csid: csid, uri:  uri)
          status.good "Transferred: #{object.identifier}"
        else
          status.bad "Error response: #{response.result.body}"
        end
      rescue StandardError => err
        status.bad "Error during transfer: #{err.message}"
      end
    else
      status.bad "Transfer requires no pre-existing csid and uri."
    end
    status
  end

  def update
    status = Status.new
    if object.has_csid_and_uri?
      Rails.logger.debug("Updating: #{object.identifier}")
      begin
        response = client.put(object.uri, object.content)
        if response.result.success?
          status.good "Updated: #{object.identifier}"
        else
          status.bad "Error response: #{response.result.body}"
        end
      rescue StandardError => err
        status.bad "Error during update: #{err.message}"
      end
    else
      status.bad "Update requires existing csid and uri."
    end
    status
  end

  def ping
    status = Status.new
    message_string = "#{service[:path]} #{service[:schema]} #{service[:identifier_field]} #{object.identifier}"
    response = perform_search_request

    unless response.result.success?
      status.bad "Error searching #{message_string}"
      return status
    end
    list_type, list_item = list_criteria

    result_count = response.parsed[list_type]["totalItems"].to_i
    if result_count == 0
      object.update_attributes!(csid: nil, uri: nil)
      status.good 'Record was not found.'
    elsif result_count == 1
      object.update_attributes!(
        csid: response.parsed[list_type][list_item]["csid"],
        uri:  response.parsed[list_type][list_item]["uri"].gsub(/^\//, '')
      )
      status.good 'Record was found.'
    else
      status.bad "Ambiguous result count (#{result_count}) for #{message_string}"
    end
    status
  end

  def self.find_item_csid(service, identifier)
    response = RemoteActionService.perform_search_request(
      service: service,
      value: identifier
    )
    return nil unless response.result.success?
    return nil if response.parsed['abstract_common_list']['totalItems'].to_i != 1

    response.parsed['abstract_common_list']['list_item']['csid']
  end

  def self.perform_relations_request(subject_csid:, object_csid:)
    Rails.configuration.client.get(
      'relations', query: { 'sbj' => subject_csid, 'obj' => object_csid }
    )
  end

  def self.perform_search_request(service:, value:)
    search_args = {
      path: service[:path],
      namespace: "#{service[:schema]}_common",
      field: service[:identifier_field],
      expression: "= '#{value}'"
    }
    query = CollectionSpace::Search.new.from_hash search_args
    Rails.configuration.client.search(query)
  end
end

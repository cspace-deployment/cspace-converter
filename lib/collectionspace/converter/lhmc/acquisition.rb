# frozen_string_literal: true

require_relative '../core/acquisition'

module CollectionSpace
  module Converter
    module Lhmc
      class LhmcAcquisition < CoreAcquisition
        ::LhmcAcquisition = CollectionSpace::Converter::Lhmc::LhmcAcquisition
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = %w[
                          # not in lhmc
                          objectofferpricecurrency
                          objectofferpricevalue
                          objectpurchaseoffercurrency
                          objectpurchaseoffervalue
                          originalobjectpurchasepricecurrency
                          originalobjectpurchasepricevalue
                         ]
        end
        
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:acquisitions_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/acquisition',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end

            xml.send(
              'ns2:acquisitions_lhmc',
              'xmlns:ns2' => 'http://collectionspace.org/services/acquisition/local/lhmc',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_lhmc(xml, attributes)
            end
          end
        end

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))
        end

        def map_lhmc(xml, attributes)
          #receivedByGroupList, receivedByGroup
          received_data = {
            'receivedbylocal' => 'receivedBy',
            'receivedbyulan' => 'receivedBy',
            'receiveddate' => 'receivedDate'
          }
          received_transforms = {
            'receivedbylocal' => { 'authority' => %w[personauthorities person] },
            'receivedbyulan' => { 'authority' => %w[personauthorities ulan_pa] },
            'receiveddate' => { 'special' => 'unstructured_date_stamp' }
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'received',
            received_data,
            received_transforms
          )
        end
      end
    end
  end
end

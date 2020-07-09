# frozen_string_literal: true

require_relative '../anthro/taxon'

module CollectionSpace
  module Converter
    module Herbarium
      class HerbariumTaxon < AnthroTaxon
        ::HerbariumTaxon = CollectionSpace::Converter::Herbarium::HerbariumTaxon
        def redefined_fields
          @redefined = []
        end

        
        def initialize(attributes, config={})
          super(attributes, config)
        end #initialize

        def convert 
          run(wrapper: 'document') do |xml| 
            xml.send(
              'ns2:taxon_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/taxonomy',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
             ) do 
              xml.parent.namespace = nil
              HerbariumTaxon.map(xml, attributes)
            end # COMMON
            
            xml.send(
              'ns2:taxon_herbarium',
              'xmlns:ns2' => 'http://collectionspace.org/services/taxon/local/herbarium',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace = nil
              HerbariumTaxon.map_herbarium(xml, attributes)
            end
          end
        end # convert       

        def self.map(xml, attributes) 
          AnthroTaxon.map(xml, attributes.merge(redefined_fields))
        end # map

        def self.map_herbarium(xml, attributes)
          herbarium_pairs = {
            'taxonmajorgroup' => 'taxonMajorGroup',
            'taxonfamily' => 'taxonFamily',
            'taxonbasionym' => 'taxonBasionym',
          }

          herbarium_transforms = {
            'taxonmajorgroup' => {'vocab' => 'taxonmajorgroup'},
            'family' => {'authority' => ['taxonauthorities', 'taxon']},
            'taxonbasionym' => {'authority' => ['taxonauthorities', 'taxon']}
          }
          
          CSXML::Helpers.add_pairs(xml, attributes, herbarium_pairs, herbarium_transforms)

          relatedterm_data = {
            'relatedterm' => 'relatedTerm',
            'relatedtermtype' => 'relatedTermType',
            'relatedtermsource' => 'relatedTermSource',
            'relatedtermsourcedetail' => 'relatedTermSourceDetail'
          }

          relatedterm_transforms = {
            'relatedterm' => {'authority' => ['taxonauthorities', 'taxon']}, 
            'relatedtermtype' => {'vocab' => 'taxonrelatedtermtype'}
          }

          CSXML.add_single_level_group_list(xml, attributes, 'relatedTerm', relatedterm_data, relatedterm_transforms)
        end # map_herbarium

      end # class HerbariumTaxon
    end # model ucjeps
  end # module Converter
end # module CSpace
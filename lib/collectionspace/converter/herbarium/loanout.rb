# frozen_string_literal: true

require_relative '../core/loanout'

module CollectionSpace
  module Converter
    module Herbarium
      class HerbariumLoanOut < CoreLoanOut
        ::HerbariumLoanOut = CollectionSpace::Converter::Herbarium::HerbariumLoanOut

        def initialize(attributes, config={})
          super(attributes, config)
          @redefined = []
        end

        def convert
          run(wrapper: 'document')  do |xml|
            xml.send(
              'ns2:loansout_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/loanout',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end
          
            xml.send(
              'ns2:loansout_herbarium',
              'xmlns:ns2' => 'http://collectionspace.org/services/loanout/local/herbarium',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace = nil
              map_herbarium(xml, attributes)
            end # herb
          end # run
        end # def convert
        
        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))
        end

        def map_harbarium(xml,  attributes)
          # transportMethod
          # numPackages
          # acknowledgeDate

          pairs = {
            'majorgroup' => 'majorGroup',
            'shipdate' => 'shipDate',
            'transportmethod' => 'transportMethod',
            'numpackages' => 'numPackages',
            'acknowledgedate' => 'acknowledgeDate'
          }

          pairs_transforms = {
            'majorgroup' => {'vocab' => 'majortaxongroup'},
            'transportmethod' => {'vocab' => 'transportmethod'}
          }

          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        
          # geo group
          repeats = {
            'geography' => ['geographyList', 'geography'],
            'taxonomy' => ['taxonomyList', 'taxonomy'],
            'objKind' => ['objKindList', 'objKind']
          }

          repeats_transforms = {
            'taxonomy' =>  {'authority' => ['taxonauthorities', 'taxon']},
            'objKind' => {'vocab' => 'objectkind'}
          }

          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)

        end

      end # class
    end # Herbarium
  end # Converter
end # CollectionSpace

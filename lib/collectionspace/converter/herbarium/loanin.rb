# frozen_string_literal: true

require_relative '../core/loanin'

module CollectionSpace
  module  Converter
    module Herbarium
      class HerbariumLoanIn < CoreLoanIn
        ::HerbariumLoanIn =  CollectionSpace::Converter::Herbarium::HerbariumLoanIn
        
        def initialize(attributes, config={})
          super(attributes, config)
          @redefined  = []
        end

        def convert
          run(wrapper: 'document') do |xml|
            xm.send(
              'ns2:loansin_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/loanin',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end

            xml.send(
              'ns2:loansin_herbarium',
              'xmlns:ns2' => 'http://collectionspace.org/services/loanin/local/herbarium',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace  = nil
              map_harbarium(xml, attributes)
            end  
          end # run
        end #convert

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))
        end

        def map_harbarium(xml,  attributes)
          pairs = {
            'majorgroup' => 'majorGroup',
            'shipdate' => 'shipDate',
            'duedate' => 'dueDate',
            'transferindate' => 'transferInDate',
            'transferinorg' => 'transferInOrg',
            'transferinperson' => 'transferInPerson',
          }

          pairs_transforms = {
            'majorgroup' => {'vocab' => 'majortaxongroup'},
            'transferinorg' => {'authority' => ['orgauthorities', 'organization']},
            'transferinperson' => {'authority' => ['personauthorities', 'person']}
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

        # TO DO: Add natural history extensions
      end # class loainin
    end # mod herb
  end # mod conv
end # mod  cspace


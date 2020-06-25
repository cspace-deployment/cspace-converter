# frozen_string_literal: true

require_relative '../core/collectionobject'

module  CollectionSpace 
  module Converter
    module Herbarium
      class  HerbariumCollectionObject < CoreCollectionObject
        ::HerbariumCollectionObject = CollectionSpace::Converter::Herbarium::HerbariumCollectionObject
      
        def initialize(attributes, config={})
          super(attributes, config)
          @redefined = [
            #phase  (to vocab -> botanicalphase)
            # forms/form   (to vocab  -> herbariumform)
          ]
        end  # init

        def convert 
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:collectionobjects_common'
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do 
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end # common

            xml.send(
              'ns2:collectionobjects_herbarium',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/local/herbarium',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_herbarium(xml, attributes)
            end # herb
          end  # convert


          def map_common(xml, attributes)  
            super(xml, attributes.merge(redefined_fields))
            # TO DO: Add new transforms
          end # map_common

          def map_herbarium(xml, attributes)
            pairs = {
              'hybridname' => 'hybridName', 
              'labelheader' =>  'labelHeader',
              'labelfooter' => 'labelFooter',
              'sheetnumber' =>  'sheetNumber', 
              'sheetcount' => 'sheetCount',
              'posttopublic' => 'postToPublic',
              'habitat' => 'habitat',
            }

            pairs_transforms = {
              'labelheader' => {'authority' => ['conceptauthorities', 'labeltext']},
              'labelfooter' => {'authority' => ['conceptauthorities', 'labeltext']},
              'posttopublic' => {'vocab' => 'yesnovalues'} # does capitalization matter? yesNoValues
            }

            CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
            
            localname_data = {
              'localname' => 'localName',
              'localnamelanguage' => 'localNameLanguage'
            }

            localname_transforms = {
              'localnamelanguage' => {'vocab' => 'languages'}
            }

            CSXML.add_single_level_group_list(xml, attributes, 'localName', localname_data, localname_transforms)

            
            herbhybridparent_data = {
              'herbhybridparent' => 'herbHybridParent',
              'herbhybridparentqualifier' => 'herbHybridParentQualifier'
            }

            herbhybridparent_transforms = {
              'herbhybridparent' => {'authority' => ['taxonauthorities', 'taxon']}
              'herbhybridparentqualifier' => {'vocab' => 'hybridparentqualifier'}
            }
            CSXML.add_single_level_group_list(xml, attributes, 'herbHybridParent', herbhybridparent_data, herbhybridparent_transforms)


            herbtypespecimen_data = {
              'herbtypespecimenkind' => 'herbTypeSpecimenKind', 
              'herbtypespecimenassertionBy' => 'herbTypeSpecimenAssertionBy',
              'herbtypespecimenreference' => 'herbTypeSpecimenReference',
              'herbtypespecimenrefPage' => 'herbTypeSpecimenRefPage',
              'herbtypespecimenbasionym' => 'herbTypeSpecimenBasionym', 
              'herbtypespecimennotes' => 'herbTypeSpecimenNotes'
            }

            herbtypespecimen_transforms = {
              'herbtypespecimenkind' => {'vocab' => 'typespecimenkind'},
              'herbtypespecimenassertionBy' => {'authority' => ['orgauthorities', 'organization']},
              'herbtypespecimenbasionym' => {'authority' => ['taxonauthorities', 'taxon']}  # add local?
            }

            CSXML.add_single_level_group_list(xml, attributes, 'herbTypeSpecimen', herbtypespecimen_data, herbtypespecimen_transforms)

            herbassociatedtaxa_data = {
              'herbassoctaxon' => 'herbAssocTaxon',
              'herbassoctaxoncommonname' => 'herbAssocTaxonCommonName',
              'herbassoctaxoninteraction' => 'herbAssocTaxonInteraction'
            }
            herbassociatedtaxa_transforms = {
              'herbassoctaxon' =>  {'authority' => ['taxonauthorities', 'taxon']},  # add local?
              'herbassoctaxoninteraction' => {'vocab' => 'assoctaxoninteraction'}
            }

            CSXML.add_single_level_group_list(xml, attributes, 'herbAssocTaxon', herbassociatedtaxa_data, herbassociatedtaxa_transforms)

            herblocality_data = {
              'herbcollectionlocationverbatim' => 'herbCollectionLocationVerbatim',
              'herbcollectionplace' => 'herbCollectionPlace'
            }
            herblocality_transforms = {
              'herbcollectionplace' => {'authority' => ['placeauthorities' ,'place']}
            }

            CSXML.add_single_level_group_list(xml, attributes, 'herbLocality' herblocality_data, herblocality_transforms)
          end # map_herb

          # TO DO: Add extension

      end # class
    end # herb
  end # converter
end # cspace

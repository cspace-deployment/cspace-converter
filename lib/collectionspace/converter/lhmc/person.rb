module CollectionSpace
  module Converter
    module Lhmc
      class LhmcPerson < CorePerson
        ::LhmcPerson = CollectionSpace::Converter::Lhmc::LhmcPerson


        def redefined_fields
          @redefined.concat([
            # source overridden
            'birthplace',
            'deathplace'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            # The xml.send wraps all fields in the <collectionobjects_common> element and defines
            #  the namespace attributes
            xml.send(
              'ns2:persons_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/person',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              # NOTE that we are calling the map_common method of LhmcCollectionObject!
              #  This calls CoreCollectionObject.map_common (with overridden fields removed)
              #  to populate all non-overridden fields AND defines the logic for any overridden fields
              LhmcPerson.map_common(xml, attributes, redefined_fields, config)
            end

            xml.send(
              'ns2:persons_lhmc',
              'xmlns:ns2' => 'http://collectionspace.org/services/person/local/lhmc',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              # The map_lhmc method defines conversion logic for fields defined in the lhmc data
              #   profile
              # This logic cannot override itself, so we don't send the redefined_fields!
              LhmcPerson.map_lhmc(xml, attributes)
            end

            xml.send(
              "ns2:contacts_common",
              "xmlns:ns2" => "http://collectionspace.org/services/contact",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              LhmcPerson.map_contact(xml, attributes, redefined_fields)
            end
          end
        end

        # CORE
        def self.map_common(xml, attributes, config, redefined)
          # map non-overridden fields according to core logic
          CorePerson.map_common(xml, attributes.merge(redefined), config)

          # OVERRIDES
          pairs = {
            'birthplacelocal' => 'birthPlace',
            'birthplacetgn' => 'birthPlace',
            'deathplacelocal' => 'deathPlace',
            'deathplacetgn' => 'deathPlace'
          }
          pairs_transforms = {
            'birthplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'birthplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']},
            'deathplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'deathplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end
        # PROFILE
        def self.map_lhmc(xml, attributes)
          pairs = {
            'relatedpersonlocal' => 'relatedPerson',
            'relatedpersonulan' => 'relatedPerson',
            'relationshiptype' => 'relationshipType',
            'relationshipnote' => 'relationshipNote',
            'placeorresidencelocal' => 'placeOrResidence',
            'placeorresidencetgn' => 'placeOrResidence',
            'placenote' => 'placeNote'
          }
          pairs_transforms = {
            'relatedpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'relatedpersonulan' => {'authority' => ['personauthorities', 'ulan_pa']},
            'relationshiptype' => {'vocab' => 'personrelationship'},
            'placeorresidencelocal' => {'authority' => ['placeauthorities', 'place']},
            'placeorresidencetgn' => {'authority' => ['placeauthorities', 'tgn_place']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)

          # publicationsPersonGroupList, publicationsPersonGroup
          #  this field should be read as: "publications (for this) Person"
          pubdata = {
            'publicationspersonlocal' => 'publicationsPerson',
            'publicationspersonworldcat' => 'publicationsPerson',
            'publicationspersonnote' => 'publicationsPersonNote'
          }
          pubtransforms = {
            'publicationspersonlocal' => {'authority' => ['citationauthorities', 'citation']},
            'publicationspersonworldcat' => {'authority' => ['citationauthorities', 'worldcat']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'publicationsPerson',
            pubdata,
            pubtransforms
          )
        end

        def self.map_contact(xml, attributes, redefined)
          Contact.map_contact(xml, attributes.merge(redefined))
        end        

      end #class LhmcPerson
    end #module Lhmc
  end #module Converter
end #module CollectionSpace

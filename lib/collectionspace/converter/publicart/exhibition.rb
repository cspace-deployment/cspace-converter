module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtExhibition < Exhibition
        ::PublicArtExhibition = CollectionSpace::Converter::PublicArt::PublicArtExhibition
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'sponsor',
            'workinggrouptitle',
            'workinggroupnote',
            'exhibitionperson',
            'exhibitionpersonrole',
            'exhibitionreference',
            'exhibitionreferencetype',
            'exhibitionreferencenote',
            'exhibitionsectionname',
            'exhibitionsectionlocation',
            'exhibitionsectionobjects',
            'exhibitionsectionnote',
            'exhibitionstatus',
            'exhibitionstatusdate',
            'exhibitionstatusnote',
            'exhibitionobjectnumber',
            'exhibitionobjectname',
            'exhibitionobjectconscheckdate',
            'exhibitionobjectconstreatment',
            'exhibitionobjectmount',
            'exhibitionobjectsection',
            'exhibitionobjectcase',
            'exhibitionobjectseqNum',
            'exhibitionobjectrotation',
            'exhibitionobjectnote',
            # overridden by publicart
            'organizer',
            'venue'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:exhibitions_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              'ns2:exhibitions_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.map_publicart(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, redefined)
          CoreExhibition.map_common(xml, attributes.merge(redefined))
          repeats = {
            'organizerorganizationlocal' => ['organizers', 'organizer'],
            'organizerpersonlocal' => ['organizers', 'organizer'],
            'organizerorganizationshared' => ['organizers', 'organizer'],
            'organizerpersonshared' => ['organizers', 'organizer'],

          }
          repeatstransforms = {
            'organizerorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'organizerpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'organizerorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'organizerpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          # venueGroupList, venueGroup
          venuedata = {
            'venueorganizationlocal' => 'venue',
            'venueplacelocal' => 'venue',
            'venuestoragelocationlocal' => 'venue',
            'venueorganizationshared' => 'venue',
            'venueplaceshared' => 'venue',
            'venuestoragelocationoffsite' => 'venue',
            'venueopeningdate' => 'venueOpeningDate',
            'venueclosingdate' => 'venueClosingDate',
            'venueattendance' => 'venueAttendance',
            'venueurl' => 'venueUrl'
          }

          venuetransforms = {
            'venueorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'venueplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'venuestoragelocationlocal' => {'authority' => ['locationauthorities', 'location']},
            'venueorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'venueplaceshared' => {'authority' => ['placeauthorities', 'place_shared']},
            'venuestoragelocationoffsite' => {'authority' => ['locationauthorities', 'offsite_sla']},
            'venueopeningdate' => {'special' => 'unstructured_date_stamp'},
            'venueclosingdate' => {'special' => 'unstructured_date_stamp'},
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'venue',
            venuedata,
            venuetransforms
          )
          
        end

        def self.map_publicart(xml, attributes)
          #exhibitionSupportGroupList, exhibitionSupportGroup
          exhibitionsupport_data = {
            "exhibitionsupportnote" => "exhibitionSupportNote",
            "exhibitionsupportorganization" => "exhibitionSupport",
            "exhibitionsupportperson" => "exhibitionSupport"
          }
          exhibitionsupport_transforms = {
            'exhibitionsupportorganization' => {'authority' => ['orgauthorities', 'organization']},
            'exhibitionsupportperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'exhibitionSupport',
            exhibitionsupport_data,
            exhibitionsupport_transforms
          )
        end

      end
    end
  end
end

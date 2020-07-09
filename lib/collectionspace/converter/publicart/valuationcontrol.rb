module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtValuationControl < ValuationControl
        ::PublicArtValuationControl = CollectionSpace::Converter::PublicArt::PublicArtValuationControl
        def redefined_fields
          @redefined.concat([
            # not in publicart
            # overridden by publicart
            'valuesourceorganizationlocal',
            'valuesourceorganizationshared',
            'valuesourcepersonlocal',
            'valuesourcepersonshared'
          ])
          super
        end
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:valuationcontrols_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/valuationcontrol',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtValuationControl.map_common(xml, attributes, redefined_fields)
            end


            xml.send(
              'ns2:valuationcontrols_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/valuationcontrol/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtValuationControl.map_publicart(xml, attributes)
            end
          end
        end       

        def self.map_common(xml, attributes, redefined)
          CoreValuationControl.map_common(xml, attributes.merge(redefined))
          pairs = {
            'valuesourceorganizationlocal' => 'valueSource',
            'valuesourcepersonlocal' => 'valueSource',
            'valuesourceorganizationshared' => 'valueSource',
            'valuesourcepersonshared' => 'valueSource'
          }
          pairs_transforms = {
            'valuesourceorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'valuesourcepersonlocal' => {'authority' => ['personauthorities', 'person']},
            'valuesourceorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'valuesourcepersonshared' => {'authority' => ['personauthorities', 'person_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end
 
        def self.map_publicart(xml, attributes)
        pairs = {
          'valuesourcerole' => 'valueSourceRole'
        }
        pairs_transforms = {
          'valuesourcerole' => {'vocab' => 'valuationsourcerole'}
        }
        CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        #insuranceGroupList, insuranceGroup
        insurance_data = {
          "insurancenote" => "insuranceNote",
          "insurancerenewaldate" => "insuranceRenewalDate",
          "insurer" => "insurer",
          "insurancepolicynumber" => "insurancePolicyNumber"
        }
        insurance_transforms = {
          'insurancerenewaldate' => {'special' => 'unstructured_date_stamp'},
          'insurer' => {'authority' => ['personauthorities', 'person']}
        }
        CSXML.add_single_level_group_list(
          xml,
          attributes,
          'insurance',
          insurance_data,
          insurance_transforms
        )
        end
      end
    end
  end
end

module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtConditionCheck < ConditionCheck
        ::PublicArtConditionCheck = CollectionSpace::Converter::PublicArt::PublicArtConditionCheck
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'hazard',
            'hazarddate',
            'hazardnote',
            'securityrecommendations',
            'storagerequirements',
            'packingrecommendations',
            'legalreqsheldnumber',
            'salvageprioritycode',
            'salvageprioritycodedate',
            # overridden by publicart
            'conditionchecker'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:conditionchecks_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/conditioncheck',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConditionCheck.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              'ns2:conditionchecks_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/conditioncheck/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConditionCheck.map_publicart(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, redefined)
          CoreConditionCheck.map_common(xml, attributes.merge(redefined))
          pairs = {
            'conditioncheckerlocalperson' => 'conditionChecker',
            'conditioncheckerlocalorganization' => 'conditionChecker',
            'conditioncheckersharedperson' => 'conditionChecker',
            'conditioncheckersharedorganization' => 'conditionChecker'
          }
          pairstransforms = {
            'conditioncheckerlocalperson' => {'authority' => ['personauthorities', 'person']},
            'conditioncheckersharedperson' => {'authority' => ['personauthorities', 'person_shared']},
            'conditioncheckerlocalorganization' => {'authority' => ['orgauthorities', 'organization']},
            'conditioncheckersharedorganization' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
        end
  
        def self.map_publicart(xml, attributes)
          pairs = {
            'installationrecommendations' => 'installationRecommendations'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
        end

      end
    end
  end
end

module CollectionSpace
  module Converter
    module Core
      class CoreLocation < Location
        ::CoreLocation = CollectionSpace::Converter::Core::CoreLocation
        def convert
          run do |xml|
            CoreLocation.map_common(xml, attributes, config)
          end
        end

        def self.map_common(xml, attributes, config)
          pairs = {
            'locationtype' => 'locationType',
            'accessnote' => 'accessNote',
            'address' => 'address',
            'securitynote' => 'securityNote'
          }
          pairstransforms = {
            'locationtype' => {'vocab' => 'locationtype'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 

          #locTermGroupList, locTermGroup
          locterm_data = {
            'termdisplayname' => 'termDisplayName',
            'termlanguage' => 'termLanguage',
            'termname' => 'termName',
            'termprefforlang' => 'termPrefForLang',
            'termqualifier' => 'termQualifier',
            'termsourcelocal' => 'termSource',
            'termsourceworldcat' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',

            'termdisplaynamenonpreferred' => 'termDisplayName',
            'termlanguagenonpreferred' => 'termLanguage',
            'termnamenonpreferred' => 'termName',
            'termprefforlangnonpreferred' => 'termPrefForLang',
            'termqualifiernonpreferred' => 'termQualifier',
            'termsourcelocalnonpreferred' => 'termSource',
            'termsourceworldcatnonpreferred' => 'termSource',
            'termsourceidnonpreferred' => 'termSourceID',
            'termsourcedetailnonpreferred' => 'termSourceDetail',
            'termsourcenotenonpreferred' => 'termSourceNote',
            'termstatusnonpreferred' => 'termStatus',
            'termtypenonpreferred' => 'termType',
            'termflagnonpreferred' => 'termFlag',
          }
          locterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsourcelocal' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},

            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcelocalnonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcatnonpreferred' => {'authority' => ['citationauthorities', 'worldcat']}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'locTerm',
            locterm_data,
            locterm_transforms
          )
          #conditionGroupList, conditionGroup
          condition_data = {
            "conditionnote" => "conditionNote",
            "conditionnotedate" => "conditionNoteDate",
          }
          condition_transforms = {
            'conditionnotedate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'condition',
            condition_data,
            condition_transforms
          )
        end
      end
    end
  end
end

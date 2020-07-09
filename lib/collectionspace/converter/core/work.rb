module CollectionSpace
  module Converter
    module Core
      class CoreWork < Work
        ::CoreWork = CollectionSpace::Converter::Core::CoreWork
        def convert
          run do |xml|
            CoreWork.map_common(xml, attributes, config)
          end
        end
        def self.map_common(xml, attributes, config)
          #addrGroupList, addrGroup
          Address.map_address(xml, attributes, ['place/local', 'place/tgn'])

          pairs = {
            'worktype' => 'workType',
            'workhistorynote' => 'workHistoryNote'
          }
          pairs_transforms = {
            'worktype' => {'vocab' => 'worktype'}
          } 
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          #workDateGroupList, workDateGroup
          CSXML::Helpers.add_date_group_list(xml, 'workDate', attributes["workdategroup"])
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #workTermGroupList, workTermGroup
          workterm_data = {
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
            'termflagnonpreferred' => 'termFlag'
          }
          workterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsourcelocal' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},
            'termflag' => {'vocab' => 'worktermflag'},

            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcelocalnonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcatnonpreferred' => {'authority' => ['citationauthorities', 'worldcat']},
            'termflagnonpreferred' => {'vocab' => 'worktermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'workTerm',
            workterm_data,
            workterm_transforms
          )
          #creatorGroupList, creatorGroup
          creator_data = {
            "creatororganization" => "creator",
            "creatorperson" => "creator",
            "creatortype" => "creatorType"
          }
          creator_transforms = {
            'creatorperson' => {'authority' => ['personauthorities', 'person']},
            'creatororganization' => {'authority' => ['orgauthorities', 'organization']},
            'creatortype' => {'vocab' => 'workcreatortype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'creator',
            creator_data,
            creator_transforms
          )
          #publisherGroupList, publisherGroup
          publisher_data = {
            "publisherorganization" => "publisher",
            "publisherperson" => "publisher",
            "publishertype" => "publisherType"
          }
          publisher_transforms = {
            'publisherperson' => {'authority' => ['personauthorities', 'person']},
            'publisherorganization' => {'authority' => ['orgauthorities', 'organization']},
            'publishertype' => {'vocab' => 'workpublishertype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publisher',
            publisher_data,
            publisher_transforms
          )
        end
      end
    end
  end
end

module CollectionSpace
  module Converter
    module Core
      class CoreCitation < Citation
        ::CoreCitation = CollectionSpace::Converter::Core::CoreCitation
        def convert
          run do |xml|
            CoreCitation.map_common(xml, attributes, config)
          end
        end

        def self.map_common(xml, attributes, config)
          pairs = {
            'citationnote' => 'citationNote'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #citationTermGroupList, citationTermGroup
          citationterm_data = {
            'termdisplayname' => 'termDisplayName',
            'termlanguage' => 'termLanguage',
            'termprefforlang' => 'termPrefForLang',
            'termsourcelocal' => 'termSource',
            'termsourceworldcat' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'termvolume' => 'termVolume',
            'termfullcitation' => 'termFullCitation',
            'termsubtitle' => 'termSubTitle',
            'termsectiontitle' => 'termSectionTitle',
            'termissue' => 'termIssue',
            'termtitle' => 'termTitle',

            'termdisplaynamenonpreferred' => 'termDisplayName',
            'termlanguagenonpreferred' => 'termLanguage',
            'termprefforlangnonpreferred' => 'termPrefForLang',
            'termsourcelocalnonpreferred' => 'termSource',
            'termsourceworldcatnonpreferred' => 'termSource',
            'termsourceidnonpreferred' => 'termSourceID',
            'termsourcedetailnonpreferred' => 'termSourceDetail',
            'termsourcenotenonpreferred' => 'termSourceNote',
            'termstatusnonpreferred' => 'termStatus',
            'termtypenonpreferred' => 'termType',
            'termflagnonpreferred' => 'termFlag',
            'termvolumenonpreferred' => 'termVolume',
            'termfullcitationnonpreferred' => 'termFullCitation',
            'termsubtitlenonpreferred' => 'termSubTitle',
            'termsectiontitlenonpreferred' => 'termSectionTitle',
            'termissuenonpreferred' => 'termIssue',
            'termtitlenonpreferred' => 'termTitle',
          }
          citationterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsourcelocal' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},
            'termtype' => {'vocab' => 'citationtermtype'},
            'termflag' => {'vocab' => 'citationtermflag'},
            'termprefforlang' => {'special' => 'boolean'},

            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcelocalnonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcatnonpreferred' => {'authority' => ['citationauthorities', 'worldcat']},
            'termtypenonpreferred' => {'vocab' => 'citationtermtype'},
            'termflagnonpreferred' => {'vocab' => 'citationtermflag'},
            'termprefforlangnonpreferred' => {'special' => 'boolean'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationTerm',
            citationterm_data,
            citationterm_transforms
          )
          #citationPublicationInfoGroupList, citationPublicationInfoGroup
          citationpublication_data = {
            "publicationplacelocal" => "publicationPlace",
            "publicationplacetgn" => "publicationPlace",
            "pages" => "pages",
            "publisher" => "publisher",
            "edition" => "edition",
            "publicationdate" => "publicationDate"
          }
          citationpublication_transforms = {
            'publicationdate' => {'special' => 'structured_date'},
            'publicationplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'publicationplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']},
            'publisher' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationPublicationInfo',
            citationpublication_data,
            citationpublication_transforms
          )
          #citationAgentInfoGroupList, citationAgentInfoGroup
          citationagent_data = {
            "agentorganization" => "agent",
            "agentpersonlocal" => "agent",
            "agentpersonulan" => "agent",
            "role" => "role",
            "note" => "note"
          }
          citationagent_transforms = {
            'agentorganization' => {'authority' => ['orgauthorities', 'organization']},
            'agentpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'agentpersonulan' => {'authority' => ['personauthorities', 'ulan_pa']},
            'role' => {'vocab' => 'agentinfotype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationAgentInfo',
            citationagent_data,
            citationagent_transforms
          )
          #citationResourceIdentGroupList, citationResourceIdentGroup
          citationresourceident_data = {
            "resourceident" => "resourceIdent",
            "capturedate" => "captureDate",
            "type" => "type"
          }
          citationresourceident_transforms = {
            'type' => {'vocab' => 'resourceidtype'},
            'capturedate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationResourceIdent',
            citationresourceident_data,
            citationresourceident_transforms
          )
          #citationRelatedTermsGroupList, citationRelatedTermsGroup
          citationrelatedterms_data = {
            "relatedtermassociated" => "relatedTerm",
            "relatedtermactivity" => "relatedTerm",
            "relatedtermmaterial" => "relatedTerm",
            "relationtype" => "relationType"
          }
          citationrelatedterms_transforms = {
            'relatedtermassociated' => {'authority' => ['conceptauthorities', 'concept']},
            'relatedtermactivity' => {'authority' => ['conceptauthorities', 'activity']},
            'relatedtermmaterial' => {'authority' => ['conceptauthorities', 'material_ca']},
            'relationtype' => {'vocab' => 'relationtypetype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationRelatedTerms',
            citationrelatedterms_data,
            citationrelatedterms_transforms
          )
        end
      end
    end
  end
end

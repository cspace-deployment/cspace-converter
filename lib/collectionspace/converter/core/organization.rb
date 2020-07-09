module CollectionSpace
  module Converter
    module Core
      class CoreOrganization < Organization
        ::CoreOrganization = CollectionSpace::Converter::Core::CoreOrganization
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:organizations_common",
              "xmlns:ns2" => "http://collectionspace.org/services/organization",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CoreOrganization.map_common(xml, attributes, config)
            end

            xml.send(
              "ns2:contacts_common",
              "xmlns:ns2" => "http://collectionspace.org/services/contact",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              Contact.map_contact(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, config)
          pairs = {
            'foundingplace' => 'foundingPlace'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          repeats = {
            'group' => ['groups', 'group'],
            'function' => ['functions', 'function'],
            'historynote' => ['historyNotes', 'historyNote'],
            'organizationrecordtype' => ['organizationRecordTypes', 'organizationRecordType']
          }
          repeats_transforms = {
            'organizationrecordtype' => {'vocab' => 'organizationtype'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
          #dissolutionDateGroup
          CSXML::Helpers.add_date_group(xml, 'dissolutionDate', CSDTP.parse(attributes['dissolutiondate']))
          #foundingDateGroup
          CSXML::Helpers.add_date_group(xml, 'foundingDate', CSDTP.parse(attributes['foundingdate']))
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #orgTermGroupList, orgTermGroup
          orgterm_data = {
            'termdisplayname' => 'termDisplayName',
            'termlanguage' => 'termLanguage',
            'termname' => 'termName',
            'termprefforlang' => 'termPrefForLang',
            'termqualifier' => 'termQualifier',
            'termsource' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'mainbodyname' => 'mainBodyName',
            'additionstoname' => 'additionsToName',

            'termdisplaynamenonpreferred' => 'termDisplayName',

            'termlanguagenonpreferred' => 'termLanguage',
            'termnamenonpreferred' => 'termName',
            'termprefforlangnonpreferred' => 'termPrefForLang',
            'termqualifiernonpreferred' => 'termQualifier',
            'termsourcenonpreferred' => 'termSource',
            'termsourceidnonpreferred' => 'termSourceID',
            'termsourcedetailnonpreferred' => 'termSourceDetail',
            'termsourcenotenonpreferred' => 'termSourceNote',
            'termstatusnonpreferred' => 'termStatus',
            'termtypenonpreferred' => 'termType',
            'termflagnonpreferred' => 'termFlag',
            'mainbodynamenonpreferred' => 'mainBodyName',
            'additionstonamenonpreferred' => 'additionsToName'
          }

          orgterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'orgtermflag'},

            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcenonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termflagnonpreferred' => {'vocab' => 'orgtermflag'}
          }
          
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'orgTerm',
            orgterm_data,
            orgterm_transforms
          )
          #contactGroupList, contactGroup
          contact_data = {
            "contactname" => "contactName",
            "contactrole" => "contactRole",
            "contactdate" => "contactDateGroup",
            "contactenddate" => "contactEndDateGroup",
            "contactstatus" => "contactStatus"
          }
          contact_transforms = {
            'contactname' => {'authority' => ['personauthorities', 'person']},
            'contactrole' => {'vocab' => 'contactrole'},
            'contactdate' => {'special' => 'structured_date'},
            'contactenddate' => {'special' => 'structured_date'},
            'contactstatus' => {'vocab' => 'contactstatus'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contact',
            contact_data,
            contact_transforms
          )
        end
      end
    end
  end
end

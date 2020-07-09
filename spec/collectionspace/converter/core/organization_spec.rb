require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreOrganization do
  let(:attributes) { get_attributes('core', 'authorg_core_all.csv') }
  let(:coreorganization) { CoreOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(coreorganization) }
  let(:record) { get_fixture('core_organization.xml') }

  describe 'map_common' do
    p = '/document/organizations_common'
    context 'For maximally populuated record' do
      context 'For string fields' do
        [
    "#{p}/orgTermGroupList/orgTermGroup/termDisplayName",
    "#{p}/orgTermGroupList/orgTermGroup/mainBodyName",
    "#{p}/orgTermGroupList/orgTermGroup/termName",
    "#{p}/orgTermGroupList/orgTermGroup/additionsToName",
    "#{p}/orgTermGroupList/orgTermGroup/termPrefForLang",
    "#{p}/orgTermGroupList/orgTermGroup/termType",
    "#{p}/orgTermGroupList/orgTermGroup/termQualifier",
    "#{p}/orgTermGroupList/orgTermGroup/termSourceID",
    "#{p}/orgTermGroupList/orgTermGroup/termSourceDetail",
    "#{p}/orgTermGroupList/orgTermGroup/termSourceNote",
    "#{p}/orgTermGroupList/orgTermGroup/termStatus",
    "#{p}/foundingPlace",
    "#{p}/groups/group",
    "#{p}/functions/function",
    "#{p}/historyNotes/historyNote",
    "#{p}/foundingDateGroup/dateDisplayDate",
    "#{p}/dissolutionDateGroup/dateDisplayDate",
    "#{p}/foundingDateGroup/dateDisplayDate",
    "#{p}/contactGroupList/contactGroup/contactEndDateGroup/dateDisplayDate",
    "#{p}/contactGroupList/contactGroup/contactDateGroup/dateDisplayDate"
        ].each do |xpath|
          context "for xpath: #{xpath}" do
            it 'is populated' do
              expect(get_text(doc, xpath)).to_not be_empty
            end
            
            it 'matches sample payload' do
              expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
            end
          end
        end
      end

      context 'authority/vocabulary fields' do
        [
          "#{p}/contactGroupList/contactGroup/contactStatus",
          "#{p}/orgTermGroupList/orgTermGroup/termFlag",
          "#{p}/contactGroupList/contactGroup/contactName",
          "#{p}/contactGroupList/contactGroup/contactRole",
          "#{p}/orgTermGroupList/orgTermGroup/termSource",
          "#{p}/organizationRecordTypes/organizationRecordType",
          "#{p}/orgTermGroupList/orgTermGroup/termLanguage",
        ].each do |xpath|
          context xpath.to_s do
            it 'all values will be URNs' do
              expect(urn_values(doc, xpath)).not_to include('Not a URN')
            end
            
            it 'URNs match sample payload' do
              expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
            end
          end
        end      
      end
    end
    
    context 'For minimally populated record' do
      let(:attributes) { get_attributes_by_row('core', 'authorg_core_all.csv', 15) }
      let(:doc) { get_doc(coreorganization) }
      let(:record) { get_fixture('core_organization_row15.xml') }

      [
        "/document/organizations_common/orgTermGroupList/orgTermGroup/termDisplayName"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'is populated' do
            expect(get_text(doc, xpath)).to_not be_empty
          end
          
          it 'matches sample payload' do
            expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
          end
        end
      end
    end    
  end
end

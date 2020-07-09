require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreWork do
  let(:attributes) { get_attributes('core', 'authwork_core_all.csv') }
  let(:corework) { CoreWork.new(Lookup.profile_defaults('work').merge(attributes)) }
  let(:doc) { get_doc(corework) }
  let(:record) { get_fixture('core_work.xml') }
  let(:xpaths) {[





  ]}

  describe '#map_common' do
    ns = 'works_common'
    context 'For maximally populuated record' do      
      context 'authority/vocab fields' do
        [
          "/document/#{ns}/addrGroupList/addrGroup/addressCountry",
          "/document/#{ns}/addrGroupList/addrGroup/addressMunicipality",
          "/document/#{ns}/addrGroupList/addrGroup/addressStateOrProvince",
          "/document/#{ns}/addrGroupList/addrGroup/addressType",
          "/document/#{ns}/creatorGroupList/creatorGroup/creator",
          "/document/#{ns}/creatorGroupList/creatorGroup/creatorType",
          "/document/#{ns}/publisherGroupList/publisherGroup/publisher",
          "/document/#{ns}/publisherGroupList/publisherGroup/publisherType",
          "/document/#{ns}/workTermGroupList/workTermGroup/termFlag",
          "/document/#{ns}/workTermGroupList/workTermGroup/termLanguage",
          "/document/#{ns}/workTermGroupList/workTermGroup/termSource",
          "/document/#{ns}/workType"
        ].each do |xpath|
          context "#{xpath}" do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end

            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
      
      context 'structured date fields' do
        [
          "/document/#{ns}/workDateGroupList/workDateGroup/dateDisplayDate"
        ].each do |xpath|
          context "#{xpath}" do
            it 'is not empty' do
              expect(doc.xpath(xpath).size).to_not eq(0)
            end

            it 'matches sample payload' do
              expect(get_structured_date(doc, xpath)).to eq(get_structured_date(record, xpath))
            end
          end
        end
      end

    context 'regular fields' do
        [
          "/document/#{ns}/addrGroupList/addrGroup/addressPlace1",
          "/document/#{ns}/addrGroupList/addrGroup/addressPlace2",
          "/document/#{ns}/addrGroupList/addrGroup/addressPostCode",
          "/document/#{ns}/workHistoryNote",
          "/document/#{ns}/workTermGroupList/workTermGroup/termDisplayName",
          "/document/#{ns}/workTermGroupList/workTermGroup/termName",
          "/document/#{ns}/workTermGroupList/workTermGroup/termPrefForLang",
          "/document/#{ns}/workTermGroupList/workTermGroup/termQualifier",
          "/document/#{ns}/workTermGroupList/workTermGroup/termSourceDetail",
          "/document/#{ns}/workTermGroupList/workTermGroup/termSourceID",
          "/document/#{ns}/workTermGroupList/workTermGroup/termSourceNote",
          "/document/#{ns}/workTermGroupList/workTermGroup/termStatus",
          "/document/#{ns}/workTermGroupList/workTermGroup/termType"
        ].each do |xpath|
          context "#{xpath}" do
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end
    
    context 'For minimally populated record' do
      let(:attributes) { get_attributes_by_row('core', 'authwork_core_all.csv', 12) }
      let(:doc) { get_doc(corework) }
      let(:record) { get_fixture('core_work_row12.xml') }
      let(:xpath_required) {[
        "/document/*/workTermGroupList/workTermGroup/termDisplayName"
      ]}

      it 'Maps required field(s) correctly without falling over' do
        test_converter(doc, record, xpath_required)
      end
    end
  end
end

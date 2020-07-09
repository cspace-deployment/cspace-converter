require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreLocation do
  let(:attributes) { get_attributes('core', 'location_core_all.csv') }
  let(:corelocation) { CoreLocation.new(attributes) }
  let(:doc) { get_doc(corelocation) }
  let(:record) { get_fixture('core_location.xml') }

  describe '#map_common' do
    ns = 'locations_common'
    context 'For maximally populuated record' do

      context 'authority/vocab fields' do
        [
          "/document/#{ns}/locTermGroupList/locTermGroup/termLanguage",
          "/document/#{ns}/locTermGroupList/locTermGroup/termSource"
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
      
      context 'regular fields' do
        [
          "/document/#{ns}/locTermGroupList/locTermGroup/termDisplayName",
          "/document/#{ns}/locTermGroupList/locTermGroup/termPrefForLang",
          "/document/#{ns}/locTermGroupList/locTermGroup/termType",
          "/document/#{ns}/locTermGroupList/locTermGroup/termQualifier",
          "/document/#{ns}/locTermGroupList/locTermGroup/termSourceID",
          "/document/#{ns}/locTermGroupList/locTermGroup/termSourceDetail",
          "/document/#{ns}/locTermGroupList/locTermGroup/termSourceNote",
          "/document/#{ns}/locTermGroupList/locTermGroup/termStatus",
          "/document/#{ns}/locTermGroupList/locTermGroup/termName",
          "/document/#{ns}/locationType",
          "/document/#{ns}/accessNote",
          "/document/#{ns}/address",
          "/document/#{ns}/conditionGroupList/conditionGroup/conditionNote",
          "/document/#{ns}/conditionGroupList/conditionGroup/conditionNoteDate",
          "/document/#{ns}/securityNote"
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
      let(:attributes) { get_attributes_by_row('core', 'location_core_all.csv', 7) }
      let(:doc) { Nokogiri::XML(corelocation.convert, nil, 'UTF-8') }
      let(:record) { get_fixture('core_location_row7.xml') }
      let(:xpath_required) {[
        "/document/*/locTermGroupList/locTermGroup/termDisplayName"
      ]}

      it 'Maps required field(s) correctly without falling over' do
        test_converter(doc, record, xpath_required)
      end
    end
  end
end

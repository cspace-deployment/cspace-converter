require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CorePerson do
  let(:attributes) { get_attributes('core', 'authperson_core_all.csv') }
  let(:coreperson) { CorePerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(coreperson) }
  let(:record) { get_fixture('core_person.xml') }
  let(:p) { 'persons_common' }

  describe '#map_common' do
    context 'For maximally populuated record' do
      context 'authority/vocab fields' do
        [
          "/document/#{p}/personTermGroupList/personTermGroup/termLanguage",
          "/document/#{p}/personTermGroupList/personTermGroup/termSource"
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
          "/document/#{p}/birthDateGroup",
          "/document/#{p}/deathDateGroup"
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
          "/document/#{p}/personTermGroupList/personTermGroup/termDisplayName",
          "/document/#{p}/personTermGroupList/personTermGroup/termName",
          "/document/#{p}/personTermGroupList/personTermGroup/foreName",
          "/document/#{p}/personTermGroupList/personTermGroup/middleName",
          "/document/#{p}/personTermGroupList/personTermGroup/surName",
          "/document/#{p}/personTermGroupList/personTermGroup/initials",
          "/document/#{p}/personTermGroupList/personTermGroup/salutation",
          "/document/#{p}/personTermGroupList/personTermGroup/title",
          "/document/#{p}/personTermGroupList/personTermGroup/nameAdditions",
          "/document/#{p}/personTermGroupList/personTermGroup/termPrefForLang",
          "/document/#{p}/personTermGroupList/personTermGroup/termType",
          "/document/#{p}/personTermGroupList/personTermGroup/termQualifier",
          "/document/#{p}/personTermGroupList/personTermGroup/termSourceID",
          "/document/#{p}/personTermGroupList/personTermGroup/termSourceDetail",
          "/document/#{p}/personTermGroupList/personTermGroup/termSourceNote",
          "/document/#{p}/personTermGroupList/personTermGroup/termStatus",
          "/document/#{p}/birthPlace",
          "/document/#{p}/deathPlace",
          "/document/#{p}/groups/group",
          "/document/#{p}/nationalities/nationality",
          "/document/#{p}/gender",
          "/document/#{p}/occupations/occupation",
          "/document/#{p}/schoolsOrStyles/schoolOrStyle",
          "/document/#{p}/bioNote",
          "/document/#{p}/nameNote"
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
      let(:attributes) { get_attributes_by_row('core', 'authperson_core_all.csv', 3) }
      let(:doc) { get_doc(coreperson) }
      let(:record) { get_fixture('core_person_row3.xml') }
      let(:xpath_required) {[
        "/document/*/personTermGroupList/personTermGroup/termDisplayName"
      ]}

          context 'regular fields' do
        [
          "/document/#{p}/personTermGroupList/personTermGroup/termDisplayName",
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
  end
end

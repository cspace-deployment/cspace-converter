require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConcept do
  let(:attributes) { get_attributes('core', 'authconcept_nomenclature_terms.csv') }
  let(:coreconcept) { CoreConcept.new(attributes, {identifier: 'TESTIDENTIFIERVALUE'}) }
  let(:doc) { get_doc(coreconcept) }
  #let(:doc) { Nokogiri::XML(coreconcept.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_concept_nomenclature_full.xml') }
  
  describe '#map_common' do
    ns = 'concepts_common'
    context 'authority/vocab fields' do
      [
        "/document/#{ns}/conceptRecordTypes/conceptRecordType",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termFlag",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termLanguage",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termSource",
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
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termDisplayName",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termName",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termQualifier",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termStatus",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termType",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/historicalStatus",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termPrefForLang",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termSourceDetail",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termSourceID",
        "/document/#{ns}/conceptTermGroupList/conceptTermGroup/termSourceNote",
        "/document/#{ns}/scopeNote",
        "/document/#{ns}/scopeNoteSource",
        "/document/#{ns}/scopeNoteSourceDetail",
        "/document/#{ns}/citationGroupList/citationGroup/citationSource",
        "/document/#{ns}/citationGroupList/citationGroup/citationSourceDetail",
        "/document/#{ns}/additionalSourceGroupList/additionalSourceGroup/additionalSource",
        "/document/#{ns}/additionalSourceGroupList/additionalSourceGroup/additionalSourceNote",
        "/document/#{ns}/additionalSourceGroupList/additionalSourceGroup/additionalSourceDetail",
        "/document/#{ns}/additionalSourceGroupList/additionalSourceGroup/additionalSourceID"
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

    it "sets shortIdentifier" do
      xpath = '/document/*/shortIdentifier'
      conv_text = get_text(doc, xpath)
      expect(conv_text).to eq('TESTIDENTIFIERVALUE')
    end
  end
end

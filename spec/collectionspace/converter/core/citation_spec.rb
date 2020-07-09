require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCitation do
  let(:attributes) { get_attributes('core', 'authcitation_core_all.csv') }
  let(:corecitation) { CoreCitation.new(Lookup.profile_defaults('citation').merge(attributes)) }
  let(:doc) { get_doc(corecitation) }
  let(:record) { get_fixture('core_citation.xml') }
  let(:xpaths) {[

    


  ]}

  describe '#map_common' do
    ns = 'citations_common'
    context 'For maximally populuated record' do
      context 'authority/vocab fields' do
        [
          "/document/#{ns}/citationAgentInfoGroupList/citationAgentInfoGroup/agent",
          "/document/#{ns}/citationAgentInfoGroupList/citationAgentInfoGroup/role",
          "/document/#{ns}/citationPublicationInfoGroupList/citationPublicationInfoGroup/publicationPlace",
          "/document/#{ns}/citationPublicationInfoGroupList/citationPublicationInfoGroup/publisher",
          "/document/#{ns}/citationRelatedTermsGroupList/citationRelatedTermsGroup/relatedTerm",
          "/document/#{ns}/citationRelatedTermsGroupList/citationRelatedTermsGroup/relationType",
          "/document/#{ns}/citationResourceIdentGroupList/citationResourceIdentGroup/type",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termFlag",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termLanguage",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSource",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termType"
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
          "/document/#{ns}/citationResourceIdentGroupList/citationResourceIdentGroup/captureDate/dateDisplayDate",
          "/document/#{ns}/citationPublicationInfoGroupList/citationPublicationInfoGroup/publicationDate/dateDisplayDate"
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
          "/document/#{ns}/citationAgentInfoGroupList/citationAgentInfoGroup/note",
          "/document/#{ns}/citationNote",
          "/document/#{ns}/citationPublicationInfoGroupList/citationPublicationInfoGroup/edition",
          "/document/#{ns}/citationPublicationInfoGroupList/citationPublicationInfoGroup/pages",
          "/document/#{ns}/citationResourceIdentGroupList/citationResourceIdentGroup/resourceIdent",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termDisplayName",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termFullCitation",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termIssue",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termPrefForLang",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSectionTitle",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSourceDetail",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSourceID",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSourceNote",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termStatus",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termSubTitle",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termTitle",
          "/document/#{ns}/citationTermGroupList/citationTermGroup/termVolume"
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
      let(:attributes) { get_attributes_by_row('core', 'authcitation_core_all.csv', 11) }
      let(:doc) { get_doc(corecitation) }
      let(:record) { get_fixture('core_citation_row11.xml') }
      let(:xpath_required) {[
        "/document/*/citationTermGroupList/citationTermGroup/termDisplayName"
      ]}

      it 'Maps required field(s) correctly without falling over' do
        test_converter(doc, record, xpath_required)
      end
    end
  end
end

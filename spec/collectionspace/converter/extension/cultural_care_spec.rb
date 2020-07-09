require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::CulturalCare do
  let(:attributes) { get_attributes('lhmc', 'collectionobject_partial.csv') }
  let(:co) { LhmcCollectionObject.new(attributes) }
  let(:doc) { get_doc(co) }
  let(:record) { get_fixture('lhmc_collectionobject_row2.xml') }

  describe '#map_cultural_care' do
    cc = 'collectionobjects_culturalcare'

    context 'authority/vocab fields' do
      [
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requester",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationLevel",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationType",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requestOnBehalfOf"
      ].each do |xpath|
        context xpath.to_s do
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
        "/document/#{cc}/culturalCareNotes/culturalCareNote",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationDetails",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requestDate"
        ].each do |xpath|
          context xpath.to_s do
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

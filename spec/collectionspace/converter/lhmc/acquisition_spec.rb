require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Lhmc::LhmcAcquisition do
  let(:attributes) { get_attributes('lhmc', 'acquisition.csv') }
  let(:publicartacquisition) { LhmcAcquisition.new(Lookup.profile_defaults('acquisition').merge(attributes)) }
  let(:doc) { get_doc(publicartacquisition) }
  let(:record) { get_fixture('lhmc_acquisition.xml') }

  describe 'map_common' do
    p = 'acquisitions_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/objectOfferPriceCurrency",
        "/document/#{p}/objectOfferPriceValue",
        "/document/#{p}/objectPurchaseOfferPriceCurrency",
        "/document/#{p}/objectPurchaseOfferPriceValue",
        "/document/#{p}/originalObjectPurchasePriceCurrency",
        "/document/#{p}/originalObjectPurchasePriceValue",
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end
  end

  describe 'map_lhmc' do
    l = 'acquisitions_lhmc'


    context 'authority/vocab fields' do
      [
        "/document/#{l}/receivedGroupList/receivedGroup/receivedBy"
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
        "/document/#{l}/receivedGroupList/receivedGroup/receivedDate"
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

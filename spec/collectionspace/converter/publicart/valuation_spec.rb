require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtValuationControl do
  let(:attributes) { get_attributes('publicart', 'valuationcontrol_publicart_all.csv') }
  let(:publicartvaluationcontrol) { PublicArtValuationControl.new(Lookup.profile_defaults('valuationcontrol').merge(attributes)) }
  let(:doc) { get_doc(publicartvaluationcontrol) }
  let(:record) { get_fixture('publicart_valuation.xml') }

  describe 'map_common' do
    p = 'valuationcontrols_common'
    context 'fields overridden by publicart' do
      context 'when local value source' do
        [
          "/document/#{p}/valueSource"
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

      context 'when shared value source' do
        let(:attributes) { get_attributes_by_row('publicart', 'valuationcontrol_publicart_all.csv', 3) }
        let(:doc) { get_doc(publicartvaluationcontrol) }
        let(:record) { get_fixture('publicart_valuation_row3.xml') }
        [
          "/document/#{p}/valueSource"
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
      
    end
  end

  describe 'map_publicart' do
    pa = 'valuationcontrols_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insuranceNote",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insurancePolicyNumber",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insuranceRenewalDate",
      ].each do |xpath|
        context "#{xpath}" do
          let(:doctext) { get_text(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end
            
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
        end
      end
    end
    
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/valueSourceRole",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insurer",
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
  end
end

require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtConditionCheck do
  let(:attributes) { get_attributes('publicart', 'condition_check_publicart.csv') }
  let(:publicartconditioncheck) { PublicArtConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
  let(:doc) { get_doc(publicartconditioncheck) }
  let(:record) { get_fixture('publicart_conditioncheck.xml') }

  describe 'map_common' do
    p = 'conditionchecks_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/hazardGroupList/hazardGroup/hazardDate",
        "/document/#{p}/hazardGroupList/hazardGroup/hazard",
        "/document/#{p}/hazardGroupList/hazardGroup/hazardNote",
        "/document/#{p}/securityRecommendations",
        "/document/#{p}/storageRequirements",
        "/document/#{p}/packingRecommendations",
        "/document/#{p}/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldNumber",
        "/document/#{p}/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCode",
        "/document/#{p}/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCodeDate"
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'local authority/vocab fields' do
        [
          "/document/#{p}/conditionChecker"
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

      context 'shared authority/vocab fields' do
        let(:attributes) { get_attributes_by_row('publicart', 'condition_check_publicart.csv', 7) }
        let(:doc) { get_doc(publicartconditioncheck) }
        let(:record) { get_fixture('publicart_conditioncheck_row7.xml') }
        [
          "/document/#{p}/conditionChecker"
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
    pa = 'conditionchecks_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/installationRecommendations"
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
  end
end

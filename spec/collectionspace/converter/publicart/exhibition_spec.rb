require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtExhibition do
  let(:attributes) { get_attributes('publicart', 'exhibition_publicart_all.csv') }
  let(:publicartexhibition) { PublicArtExhibition.new(Lookup.profile_defaults('exhibition').merge(attributes)) }
  let(:doc) { get_doc(publicartexhibition) }
  let(:record) { get_fixture('publicart_exhibition.xml') }

  describe 'map_common' do
    p = 'exhibitions_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/sponsors/sponsor",
        "/document/#{p}/workingGroupList/workingGroup/workingGroupTitle",
        "/document/#{p}/workingGroupList/workingGroup/workingGroupNote",
        "/document/#{p}/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPerson",
        "/document/#{p}/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPersonRole",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReference",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceType",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceNote",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionName",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionLocation",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionObjects",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionNote",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatus",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusDate",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusNote",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNumber",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectName",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsCheckDate",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsTreatment",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectMount",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSection",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectCase",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSeqNum",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectRotation",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNote"
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'authority/vocab fields' do
        [
          "/document/#{p}/organizers/organizer",
          "/document/#{p}/venueGroupList/venueGroup/venue"
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
    pa = 'exhibitions_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/exhibitionSupportGroupList/exhibitionSupportGroup/exhibitionSupportNote"
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
        "/document/#{pa}/exhibitionSupportGroupList/exhibitionSupportGroup/exhibitionSupport"
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

require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtPerson do
  let(:attributes) { get_attributes('publicart', 'authperson_publicart_all.csv') }
  let(:publicartperson) { PublicArtPerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(publicartperson) }
  let(:record) { get_fixture('publicart_person.xml') }

  describe 'map_common' do
    context 'for fields not included in publicart' do
      p = 'persons_common'
      [
        "/document/#{p}/bioNote",
        "/document/#{p}/gender",
        "/document/#{p}/occupations/occupation",
        "/document/#{p}/schoolsOrStyles/schoolOrStyle",
        "/document/#{p}/groups/group",
        "/document/#{p}/nationalities/nationality",
        "/document/#{p}/nameNote"
      ].each do |xpath|
        context "xpath: #{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end
  end

  describe 'map_publicart' do
    pa = 'persons_publicart'
    # socialMedia fields are tested in extension/social_media_spec.rb
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/organizations/organization"
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
  end
end

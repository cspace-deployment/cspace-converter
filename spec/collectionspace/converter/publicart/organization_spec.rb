require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtOrganization do
  let(:attributes) { get_attributes('publicart', 'Org_auth_publicart.csv') }
  let(:publicartorganization) { PublicArtOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(publicartorganization) }
  let(:record) { get_fixture('publicart_organization.xml') }

  describe 'map_common' do
    p = 'organizations_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/contactNames/contactName",
        "/document/#{p}/groups/group",
        "/document/#{p}/functions/function"
      ].each do |xpath|
        context xpath.to_s do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'authority/vocab fields' do
      # foundingPlace is not a repeatable field
      # it does not appear in a repeatable group
      # therefore, we need 2 rows in the spreadsheet and 2 separate tests
      #  to verify the two different term sources get converted properly

      # if there were any other fields to test here, we'd list their xpaths in
      #  array and run the normal tests

      # THE FOLLOWING IS USED ONLY FOR NON-REPEATING FIELDS THAT NEED TO BE
      #  TESTED ACROSS MULTIPLE ROWS OF THE CSV
      # rows and fixtures arrays must have the same number of elements, and
      #   corresponding elements must be in the same position in respective array
      rows = [2, 3]
      let(:fixtures) { ['publicart_organization.xml', 'publicart_organization_row2.xml'] }
      let(:attributes) {
        rows.map { |r| get_attributes_by_row('publicart', 'Org_auth_publicart.csv', r) }
          .map{ |r| Lookup.profile_defaults('organization').merge(r) }
      }
      let(:objs) { attributes.map{ |attr| PublicArtOrganization.new(attr) } }
      let(:docs) { objs.map{ |obj| get_doc(obj) } }
      let(:records) { fixtures.map{ |f| get_fixture(f) } }

      [
        "/document/#{p}/foundingPlace"
      ].each do |xpath|
        rows.each_with_index do |row, i|
          context "row #{row}: #{xpath}" do
            let(:urn_vals) { urn_values(docs[i], xpath) }
            it 'is not empty' do
              verify_field_is_populated(docs[i], xpath)
            end

            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, records[i], xpath)
            end
          end
        end
      end
    end
  end

  describe 'map_publicart' do
    pa = 'organizations_publicart'
    context 'authority/vocabulary fields' do
      [
#        "/document/#{pa}/placementType", #uncommment after sample data for this field is added to CSV
        "/document/#{pa}/currentPlace"
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

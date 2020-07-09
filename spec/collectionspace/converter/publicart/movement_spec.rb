require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtMovement do
  let(:attributes) { get_attributes('publicart', 'lmi_publicart_all.csv') }
  let(:publicartmovement) { PublicArtMovement.new(Lookup.profile_defaults('movement').merge(attributes)) }
  let(:doc) { get_doc(publicartmovement) }
  let(:record) { get_fixture('publicart_movement.xml') }

  describe 'map_common' do
    p = 'movements_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/normalLocation",
        "/document/#{p}/inventoryActionRequired",
        "/document/#{p}/frequencyForInventory",
        "/document/#{p}/inventoryDate",
        "/document/#{p}/nextInventoryDate",
        "/document/#{p}/inventoryContactList/inventoryContact",
        "/document/#{p}/inventoryNote",
      ].each do |xpath|
        context xpath.to_s do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'authority/vocab fields' do
        rows = [2, 3, 11]
        let(:fixtures) { ['publicart_movement.xml', 'publicart_movement_row3.xml', 'publicart_movement_row11.xml'] }
        let(:attributes) {
          rows.map { |r| get_attributes_by_row('publicart', 'lmi_publicart_all.csv', r) }
            .map{ |r| Lookup.profile_defaults('movement').merge(r) }
        }
        let(:objs) { attributes.map{ |attr| PublicArtMovement.new(attr) } }
        let(:docs) { objs.map{ |obj| get_doc(obj) } }
        let(:records) { fixtures.map{ |f| get_fixture(f) } }

        [
          "/document/#{p}/currentLocation",
          "/document/#{p}/movementContact"
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
  end
end

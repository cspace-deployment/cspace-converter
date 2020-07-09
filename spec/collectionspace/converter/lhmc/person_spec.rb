require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Lhmc::LhmcPerson do
  let(:attributes) { get_attributes('lhmc', 'person.csv') }
  let(:lhmcperson) { LhmcPerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(lhmcperson) }
  let(:record) { get_fixture('lhmc_person_row2.xml') }

  describe 'map_common' do
    p = 'persons_common'

    context 'non-repeatable authority/vocab fields' do
      rows = [2, 3]
      let(:fixtures) { ['lhmc_person_row2.xml', 'lhmc_person_row3.xml'] }
      let(:attributes) {
        rows.map { |r| get_attributes_by_row('lhmc', 'person.csv', r) }
          .map{ |r| Lookup.profile_defaults('person').merge(r) }
      }
      let(:objs) { attributes.map{ |attr| LhmcPerson.new(attr) } }
      let(:docs) { objs.map{ |obj| get_doc(obj) } }
      let(:records) { fixtures.map{ |f| get_fixture(f) } }

      [
        "/document/#{p}/birthPlace",
        "/document/#{p}/deathPlace"
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

  describe 'map_lhmc' do
    pl = 'persons_lhmc'

    context 'repeatable authority/vocab fields' do
      [
        "/document/#{pl}/publicationsPersonGroupList/publicationsPersonGroup/publicationsPerson",
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

    context 'non-repeatable authority/vocab fields' do
      rows = [2, 3]
      let(:fixtures) { ['lhmc_person_row2.xml', 'lhmc_person_row3.xml'] }
      let(:attributes) {
        rows.map { |r| get_attributes_by_row('lhmc', 'person.csv', r) }
          .map{ |r| Lookup.profile_defaults('person').merge(r) }
      }
      let(:objs) { attributes.map{ |attr| LhmcPerson.new(attr) } }
      let(:docs) { objs.map{ |obj| get_doc(obj) } }
      let(:records) { fixtures.map{ |f| get_fixture(f) } }

      [
        "/document/#{pl}/relatedPerson",
        "/document/#{pl}/relationshipType",
        "/document/#{pl}/placeOrResidence"
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

    context 'non-authority/vocab fields' do
      [
        "/document/#{pl}/publicationsPersonGroupList/publicationsPersonGroup/publicationsPersonNote",
        "/document/#{pl}/relationshipNote",
        "/document/#{pl}/placeNote"
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
end

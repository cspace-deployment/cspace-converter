require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::Address do
  describe AuthorityConfig do
    auths = ['place/local', 'place/tgn']
    ac = AuthorityConfig.new(auths)
    describe '#ids' do
    it 'returns array of authority shortids' do
      result = ac.ids
      expected = ['local', 'tgn']
      expect(result).to eq(expected)
    end
    end
    describe '#data' do
      it 'returns mergeable hash of address_data based on authorities given' do
        result = ac.data
        expected = {
          'addressmunicipalitylocal' => 'addressMunicipality',
          'addressstateorprovincelocal' => 'addressStateOrProvince',
          'addresscountrylocal' => 'addressCountry',
          'addressmunicipalitytgn' => 'addressMunicipality',
          'addressstateorprovincetgn' => 'addressStateOrProvince',
          'addresscountrytgn' => 'addressCountry'
        }
        expect(result).to eq(expected)
      end
    end
    describe '#transforms' do
      it 'returns mergeable hash of address_transforms data based on authorities given' do
        result = ac.transforms
        expected = {
          'addresscountrylocal' => {'authority' => ['placeauthorities', 'place']},
          'addressmunicipalitylocal' => {'authority' => ['placeauthorities', 'place']},
          'addressstateorprovincelocal' => {'authority' => ['placeauthorities', 'place']},
          'addresscountrytgn' => {'authority' => ['placeauthorities', 'tgn_place']},
          'addressmunicipalitytgn' => {'authority' => ['placeauthorities', 'tgn_place']},
          'addressstateorprovincetgn' => {'authority' => ['placeauthorities', 'tgn_place']}
        }
      expect(result).to eq(expected)
      end
    end
  end
  
  describe '#map_address' do
    let(:attributes) { get_attributes('core', 'place_core_all.csv') }
    let(:po) { CorePlace.new(attributes) }
    let(:doc) { get_doc(po) }
    let(:record) { get_fixture('core_place.xml') }

    ns = 'places_common'

    context 'authority/vocab fields' do
      [
        "/document/#{ns}/addrGroupList/addrGroup/addressCountry",
        "/document/#{ns}/addrGroupList/addrGroup/addressMunicipality",
        "/document/#{ns}/addrGroupList/addrGroup/addressStateOrProvince",
      ].each do |xpath|
        context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
#                puts doc if xpath['Country']
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


require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CorePlace do
  let(:attributes) { get_attributes('core', 'place_core_all.csv') }
  let(:coreplace) { CorePlace.new(attributes) }
  let(:doc) { get_doc(coreplace) }
  let(:record) { get_fixture('core_place.xml') }

  describe '#map_common' do
    ns = 'places_common'
    context 'For maximally populuated record' do

      context 'authority/vocab fields' do
        [
          "/document/#{ns}/addrGroupList/addrGroup/addressCountry",
          "/document/#{ns}/addrGroupList/addrGroup/addressMunicipality",
          "/document/#{ns}/addrGroupList/addrGroup/addressStateOrProvince",
          "/document/#{ns}/addrGroupList/addrGroup/addressType",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoReferencedBy",
          "/document/#{ns}/placeOwnerGroupList/placeOwnerGroup/owner",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termFlag",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termLanguage",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termSource"
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

      context 'structured date fields' do
      [
        "/document/#{ns}/placeTermGroupList/placeTermGroup/nameDateGroup",
        "/document/#{ns}/placeOwnerGroupList/placeOwnerGroup/ownershipDateGroup",
      ].each do |xpath|
        context "#{xpath}" do
          it 'is not empty' do
            expect(doc.xpath(xpath).size).to_not eq(0)
          end

          it 'matches sample payload' do
            expect(get_structured_date(doc, xpath)).to eq(get_structured_date(record, xpath))
          end
        end
      end
      end

    context 'regular fields' do
        [
          "/document/#{ns}/addrGroupList/addrGroup/addressPlace1",
          "/document/#{ns}/addrGroupList/addrGroup/addressPlace2",
          "/document/#{ns}/addrGroupList/addrGroup/addressPostCode",
          "/document/#{ns}/maxDepthInMeters",
          "/document/#{ns}/maxDistanceAboveSurfaceInMeters",
          "/document/#{ns}/maxElevationInMeters",
          "/document/#{ns}/minDepthInMeters",
          "/document/#{ns}/minDistanceAboveSurfaceInMeters",
          "/document/#{ns}/minElevationInMeters",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/coordPrecision",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/coordUncertaintyInMeters",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/decimalLatitude",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/decimalLongitude",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/footprintSRS",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/footprintSpatialFit",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/footprintWKT",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefDateGroup/dateDisplayDate",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefPlaceName",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefProtocol",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefRemarks",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefSource",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geoRefVerificationStatus",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/geodeticDatum",
          "/document/#{ns}/placeGeoRefGroupList/placeGeoRefGroup/pointRadiusSpatialFit",
          "/document/#{ns}/placeNote",
          "/document/#{ns}/placeOwnerGroupList/placeOwnerGroup/ownershipNote",
          "/document/#{ns}/placeSource",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/historicalStatus",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/nameAbbrev",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/nameNote",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termDisplayName",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termName",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termPrefForLang",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termQualifier",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termSourceDetail",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termSourceID",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termSourceNote",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termStatus",
          "/document/#{ns}/placeTermGroupList/placeTermGroup/termType",
          "/document/#{ns}/placeType",
          "/document/#{ns}/vCoordSource",
          "/document/#{ns}/vCoordSourceRefId",
          "/document/#{ns}/vCoordSys",
          "/document/#{ns}/vCoordinates",
          "/document/#{ns}/vDepth",
          "/document/#{ns}/vDistanceAboveSurface",
          "/document/#{ns}/vElevation",
          "/document/#{ns}/vLatitude",
          "/document/#{ns}/vLongitude",
          "/document/#{ns}/vSpatialReferenceSystem",
          "/document/#{ns}/vUnitofMeasure"
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
    context 'For minimally populated record' do
      let(:attributes) { get_attributes_by_row('core', 'place_core_all.csv', 12) }
      let(:doc) { Nokogiri::XML(coreplace.convert, nil, 'UTF-8') }
      let(:record) { get_fixture('core_place_row12.xml') }
      let(:xpath_required) {[
        "/document/*/placeTermGroupList/placeTermGroup/termDisplayName"
      ]}

      it 'Maps required field(s) correctly without falling over' do
        test_converter(doc, record, xpath_required)
      end
    end
  end
end

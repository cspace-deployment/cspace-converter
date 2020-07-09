require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::Locality do
  let(:attributes) { get_attributes('extension', 'locality.csv') }
  let(:co) { AnthroCollectionObject.new(attributes) }
  let(:doc) { get_doc(co) }
  let(:record) { get_fixture('ext_locality.xml') }

  describe 'map_locality' do
    ns = 'collectionobjects_anthro'
    

    context 'authority/vocab fields' do
      [
        "/document/#{ns}/localityGroupList/localityGroup/fieldLocPlace",
        "/document/#{ns}/localityGroupList/localityGroup/vCoordSys"
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
        "/document/#{ns}/localityGroupList/localityGroup/geoRefDateGroup"
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
          "/document/#{ns}/localityGroupList/localityGroup/fieldLocVerbatim",
          "/document/#{ns}/localityGroupList/localityGroup/taxonomicRange",
          "/document/#{ns}/localityGroupList/localityGroup/fieldLocCounty",
          "/document/#{ns}/localityGroupList/localityGroup/fieldLocState",
          "/document/#{ns}/localityGroupList/localityGroup/fieldLocCountry",
          "/document/#{ns}/localityGroupList/localityGroup/fieldLocHigherGeography",
          "/document/#{ns}/localityGroupList/localityGroup/vLatitude",
          "/document/#{ns}/localityGroupList/localityGroup/vLongitude",
          "/document/#{ns}/localityGroupList/localityGroup/vCoordinates",
          "/document/#{ns}/localityGroupList/localityGroup/vOtherCoords",
          "/document/#{ns}/localityGroupList/localityGroup/decimalLatitude",
          "/document/#{ns}/localityGroupList/localityGroup/decimalLongitude",
          "/document/#{ns}/localityGroupList/localityGroup/geodeticDatum",
          "/document/#{ns}/localityGroupList/localityGroup/coordUncertainty",
          "/document/#{ns}/localityGroupList/localityGroup/coordUncertaintyUnit",
          "/document/#{ns}/localityGroupList/localityGroup/vDepth",
          "/document/#{ns}/localityGroupList/localityGroup/minDepth",
          "/document/#{ns}/localityGroupList/localityGroup/maxDepth",
          "/document/#{ns}/localityGroupList/localityGroup/depthUnit",
          "/document/#{ns}/localityGroupList/localityGroup/vElevation",
          "/document/#{ns}/localityGroupList/localityGroup/minElevation",
          "/document/#{ns}/localityGroupList/localityGroup/maxElevation",
          "/document/#{ns}/localityGroupList/localityGroup/elevationUnit",
          "/document/#{ns}/localityGroupList/localityGroup/vDistanceAboveSurface",
          "/document/#{ns}/localityGroupList/localityGroup/minDistanceAboveSurface",
          "/document/#{ns}/localityGroupList/localityGroup/maxDistanceAboveSurface",
          "/document/#{ns}/localityGroupList/localityGroup/distanceAboveSurfaceUnit",
          "/document/#{ns}/localityGroupList/localityGroup/localityNote",
          "/document/#{ns}/localityGroupList/localityGroup/localitySource",
          "/document/#{ns}/localityGroupList/localityGroup/localitySourceDetail",
          "/document/#{ns}/localityGroupList/localityGroup/pointRadiusSpatialFit",
          "/document/#{ns}/localityGroupList/localityGroup/footprintWKT",
          "/document/#{ns}/localityGroupList/localityGroup/footprintSRS",
          "/document/#{ns}/localityGroupList/localityGroup/footprintSpatialFit",
          "/document/#{ns}/localityGroupList/localityGroup/coordPrecision",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefencedBy",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefProtocol",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefSource",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefVerificationStatus",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefRemarks",
          "/document/#{ns}/localityGroupList/localityGroup/geoRefPlaceName"
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

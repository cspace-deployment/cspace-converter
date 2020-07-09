# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      module Locality
        ::Locality = CollectionSpace::Converter::Extension::Locality

        def map_locality(xml, attributes)
          # localityGroupList, localityGroup
          loc_data = {
            'fieldlocverbatim' => 'fieldLocVerbatim',
            'fieldlocplace' => 'fieldLocPlace',
            'taxonomicrange' => 'taxonomicRange',
            'fieldloccounty' => 'fieldLocCounty',
            'fieldlocstate' => 'fieldLocState',
            'fieldloccountry' => 'fieldLocCountry',
            'fieldlochighergeography' => 'fieldLocHigherGeography',
            'vlatitude' => 'vLatitude',
            'vlongitude' => 'vLongitude',
            'vcoordinates' => 'vCoordinates',
            'vothercoords' => 'vOtherCoords',
            'vcoordsys' => 'vCoordSys',
            'decimallatitude' => 'decimalLatitude',
            'decimallongitude' => 'decimalLongitude',
            'geodeticdatum' => 'geodeticDatum',
            'coorduncertainty' => 'coordUncertainty',
            'coorduncertaintyunit' => 'coordUncertaintyUnit',
            'vdepth' => 'vDepth',
            'mindepth' => 'minDepth',
            'maxdepth' => 'maxDepth',
            'depthunit' => 'depthUnit',
            'velevation' => 'vElevation',
            'minelevation' => 'minElevation',
            'maxelevation' => 'maxElevation',
            'elevationunit' => 'elevationUnit',
            'vdistanceabovesurface' => 'vDistanceAboveSurface',
            'mindistanceabovesurface' => 'minDistanceAboveSurface',
            'maxdistanceabovesurface' => 'maxDistanceAboveSurface',
            'distanceabovesurfaceunit' => 'distanceAboveSurfaceUnit',
            'localitynote' => 'localityNote',
            'localitysource' => 'localitySource',
            'localitysourcedetail' => 'localitySourceDetail',
            'pointradiusspatialfit' => 'pointRadiusSpatialFit',
            'footprintwkt' => 'footprintWKT',
            'footprintsrs' => 'footprintSRS',
            'footprintspatialfit' => 'footprintSpatialFit',
            'coordprecision' => 'coordPrecision',
            'georefencedby' => 'geoRefencedBy',
            'georefprotocol' => 'geoRefProtocol',
            'georefsource' => 'geoRefSource',
            'georefverificationstatus' => 'geoRefVerificationStatus',
            'georefremarks' => 'geoRefRemarks',
            'georefplacename' => 'geoRefPlaceName',
            'georefdategroup' => 'geoRefDateGroup'
          }
          loc_transforms = {
            'fieldlocplace' => { 'authority' => %w[placeauthorities place] },
            'vcoordsys' => { 'vocab' => 'vcoordsys' },
            'georefdategroup' => { 'special' => 'structured_date' }
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'locality',
            loc_data,
            loc_transforms
          )
        end
      end
    end
  end
end

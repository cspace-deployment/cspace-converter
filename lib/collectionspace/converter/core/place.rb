module CollectionSpace
  module Converter
    module Core
      class CorePlace < Place
        ::CorePlace = CollectionSpace::Converter::Core::CorePlace
        def convert
          run do |xml|
            CorePlace.map_common(xml, attributes, config)
          end
        end

        def self.map_common(xml, attributes, config)
          pairs = {
            'placetype' => 'placeType',
            'placenote' => 'placeNote',
            'placesource' => 'placeSource',
            'vcoordinates' => 'vCoordinates',
            'vlatitude' => 'vLatitude',
            'vlongitude' => 'vLongitude',
            'vcoordsys' => 'vCoordSys',
            'vspatialreferencesystem' => 'vSpatialReferenceSystem', 
            'vcoordsource' => 'vCoordSource', 
            'vcoordsourcerefid' => 'vCoordSourceRefId',
            'vunitofmeasure' => 'vUnitofMeasure',
            'velevation' => 'vElevation',
            'minelevationinmeters' => 'minElevationInMeters',
            'maxelevationinmeters' => 'maxElevationInMeters',
            'vdepth' => 'vDepth',
            'mindepthinmeters' => 'minDepthInMeters',
            'maxdepthinmeters' => 'maxDepthInMeters',
            'vdistanceabovesurface' => 'vDistanceAboveSurface',
            'mindistanceabovesurfaceinmeters' => 'minDistanceAboveSurfaceInMeters',
            'maxdistanceabovesurfaceinmeters' => 'maxDistanceAboveSurfaceInMeters'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #placeTermGroupList, placeTermGroup
          placeterm_data = {
            'termdisplayname' => 'termDisplayName',
            'termlanguage' => 'termLanguage',
            'termname' => 'termName',
            'termprefforlang' => 'termPrefForLang',
            'termqualifier' => 'termQualifier',
            'termsourcelocal' => 'termSource',
            'termsourceworldcat' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'namedategroup' => 'nameDateGroup',
            'historicalstatus' => 'historicalStatus',
            'namenote' => 'nameNote',
            'nameabbrev' => 'nameAbbrev',
            
            'termdisplaynamenonpreferred' => 'termDisplayName',
            'termlanguagenonpreferred' => 'termLanguage',
            'termnamenonpreferred' => 'termName',
            'termprefforlangnonpreferred' => 'termPrefForLang',
            'termqualifiernonpreferred' => 'termQualifier',
            'termsourcelocalnonpreferred' => 'termSource',
            'termsourceworldcatnonpreferred' => 'termSource',
            'termsourceidnonpreferred' => 'termSourceID',
            'termsourcedetailnonpreferred' => 'termSourceDetail',
            'termsourcenotenonpreferred' => 'termSourceNote',
            'termstatusnonpreferred' => 'termStatus',
            'termtypenonpreferred' => 'termType',
            'termflagnonpreferred' => 'termFlag',
            'namedategroupnonpreferred' => 'nameDateGroup',
            'historicalstatusnonpreferred' => 'historicalStatus',
            'namenotenonpreferred' => 'nameNote',
            'nameabbrevnonpreferred' => 'nameAbbrev' 
          }
          placeterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsourcelocal' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},
            'namedategroup' => {'special' => 'structured_date'},
            'termflag' => {'vocab' => 'placetermflag'},

            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcelocalnonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcatnonpreferred' => {'authority' => ['citationauthorities', 'worldcat']},
            'namedategroupnonpreferred' => {'special' => 'structured_date'},
            'termflagnonpreferred' => {'vocab' => 'placetermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeTerm',
            placeterm_data,
            placeterm_transforms
          )
          #placeOwnerGroupList, placeOwnerGroup
          owner_data = {
            "ownerorganizationlocal" => "owner",
            "ownerpersonlocal" => "owner",
            "ownershipdategroup" => "ownershipDateGroup",
            "ownershipnote" => "ownershipNote"
          }
          owner_transforms = {
            'ownerorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'ownerpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'ownershipdategroup' => {'special' => 'structured_date'},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeOwner',
            owner_data,
            owner_transforms
          )
          #addrGroupList, addrGroup
          Address.map_address(xml, attributes, ['place/local', 'place/tgn'])

          #placeGeoRefGroupList, #placeGeoRefGroup
          placegeo_data = {
            'decimallatitude' => 'decimalLatitude',
            'decimallongitude' => 'decimalLongitude',
            'geodeticdatum' => 'geodeticDatum',
            'coorduncertaintyinmeters' => 'coordUncertaintyInMeters',
            'coordprecision' => 'coordPrecision',
            'pointradiusspatialfit' => 'pointRadiusSpatialFit',
            'footprintwkt' => 'footprintWKT',
            'footprintsrs' => 'footprintSRS',
            'footprintspatialfit' => 'footprintSpatialFit',
            'georeferencedbyorganization' => 'geoReferencedBy',
            'georeferencedbyperson' => 'geoReferencedBy',
            'georefdategroup' => 'geoRefDateGroup',
            'georefprotocol' => 'geoRefProtocol',
            'georefsource' => 'geoRefSource',
            'georefverificationstatus' => 'geoRefVerificationStatus',
            'georefremarks' => 'geoRefRemarks',
            'georefplacename' => 'geoRefPlaceName' 

          }
          placegeo_transforms = {
            'georeferencedbyorganization' => {'authority' => ['orgauthorities', 'organization']},
            'georeferencedbyperson' => {'authority' => ['personauthorities', 'person']},
            'georefdategroup' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeGeoRef',
            placegeo_data,
            placegeo_transforms
          )
        end
      end
    end
  end
end

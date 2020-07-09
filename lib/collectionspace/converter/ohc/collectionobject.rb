# frozen_string_literal: true

require_relative '../anthro/collectionobject'

module CollectionSpace
  module Converter
    module OHC
      class OHCCollectionObject < AnthroCollectionObject
        ::OHCCollectionObject = CollectionSpace::Converter::OHC::OHCCollectionObject
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            # by ohc
            'assocpeople',
            'assocpeopletype',
            'assocpeoplenote',
            'objectnametype',
            'objectnamesystem',
            'objectname',
            'objectnamecurrency',
            'objectnamenote',
            'objectnamelevel',
            'objectnamelanguage'
          ]
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:collectionobjects_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end

            xml.send(
              'ns2:collectionobjects_anthro',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/anthro',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil

              map_anthro(xml, attributes)
              
            end

            xml.send(
              'ns2:collectionobjects_annotation',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/annotation',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil

              map_annotation(xml, attributes)

            end

            xml.send(
              'ns2:collectionobjects_nagpra',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/nagpra',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_nagpra(xml, attributes)
            end

            xml.send(
              'ns2:collectionobjects_ohc',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/ohc',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_ohc(xml, attributes)
            end
          end
        end # def convert

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))

          # assocPeopleGroupList , assocPeopleGroup
          assocpeopledata = {
            'assocpeople' => 'assocPeople',
            'assocpeopletype' => 'assocPeopleType',
            'assocpeoplenote' => 'assocPeopleNote'
          }
          aptransform = {
            'assocpeople' => { 'authority' => %w[conceptauthorities ethculture] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeopledata,
            aptransform
          )

          # objectNameList, objectNameGroup
          obj_name_data = {
            'objectnametype' => 'objectNameType',
            'objectnamesystem' => 'objectNameSystem',
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamenote' => 'objectNameNote',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamelanguage' => 'objectNameLanguage'
          }
          obj_name_transforms = {
            'objectnamelanguage' => { 'vocab' => 'languages' },
            'objectname' => { 'authority' => %w[conceptauthorities nomenclature] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            obj_name_data,
            obj_name_transforms,
            list_suffix: 'List'
          )
        end

        def map_ohc(xml, attributes)

          pairs = {
            'descriptionlevel' => 'descriptionLevel'
          }
          pair_transforms = {
            'descriptionlevel' => { 'vocab' => 'descriptionlevel' }
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          repeats = {
            'namedtimeperiod' => %w[namedTimePeriods namedTimePeriod]
          }
          repeat_transforms = {
            'namedtimeperiod' => { 'vocab' => 'namedtimeperiods' }
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          # oaiSiteGroupList, oaiSiteGroup
          oai_data = {
            'oaicollectionplace' => 'oaiCollectionPlace',
            'oailocverbatim' => 'oaiLocVerbatim'
          }
          oai_transforms = {
            'oaicollectionplace' => { 'authority' => %w[placeauthorities place] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'oaiSite',
            oai_data,
            oai_transforms
          )
        end
      end # class OHCCollectionObject
    end # module OHC
  end # module Converter
end # module CollectionSpace

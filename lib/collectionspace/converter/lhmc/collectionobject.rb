# frozen_string_literal: true

require_relative '../core/collectionobject'

module CollectionSpace
  module Converter
    module Lhmc
      class LhmcCollectionObject < CoreCollectionObject
        ::LhmcCollectionObject = CollectionSpace::Converter::Lhmc::LhmcCollectionObject
        include CulturalCare
        def initialize(attributes, config = {})
          super(attributes, config)
          # List all fields that will be overridden or removed here.

          # IMPORTANT: If the field to be overridden is part of a grouping of fields (repeats or group list),
          #   you need to list ALL the fields that are part of the group, and completely redefine the group
          #   here. Otherwise, you will get the value of each field not listed twice.

          # Listing a field here, but not redefining it will remove it from the new module.

          @redefined = %w[
            numbertype
            numbervalue
            contentplace
            inscriptioncontenttype
            inscriptioncontentmethod
            objectproductionplace
            assocplace
            ownershipplace
            contentscript
          ]
        end

        # convert is used to build the XML document, including the elements which group fields from
        #  different namespaces.

        # All the detailed logic for how individual fields are to be handled is defined below convert.

        # NOTE:
        # The namespace for the core module is "common" because the "core" namespace is used for fields
        #  used across the CSpace application (like record created and updated timestamps). So, that's
        #  confusing...
        def convert
          run(wrapper: 'document') do |xml|
            # The xml.send wraps all fields in the <collectionobjects_common> element and defines
            #  the namespace attributes
            xml.send(
              'ns2:collectionobjects_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              # NOTE that we are calling the map_common method of LhmcCollectionObject!
              #  This calls CoreCollectionObject map_common (with overridden fields removed)
              #  to populate all non-overridden fields AND defines the logic for any overridden fields
              map_common(xml, attributes)
            end

            xml.send(
              'ns2:collectionobjects_culturalcare',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/culturalcare',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              # Follows the same pattern as above. Note that we are not overriding any culturalcare
              #  fields at this time, but we follow the same pattern a) for consistency; and
              #  b) to make it easy to ever override a culturalcare field
              map_cultural_care(xml, attributes)
            end
          end
        end

        # CORE
        def map_common(xml, attributes)
          # map non-overridden fields according to core logic
          super(xml, attributes.merge(redefined_fields))

          # OVERRIDES
          pairs = {
            'ownershipplacelocal' => 'ownershipPlace',
            'ownershipplacetgn' => 'ownershipPlace'
          }
          pairs_transforms = {
            'ownershipplacelocal' => { 'authority' => %w[placeauthorities place] },
            'ownershipplacetgn' => { 'authority' => %w[placeauthorities tgn_place] }
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)

          repeats = {
            'contentplacelocal' => %w[contentPlaces contentPlace],
            'contentplacetgn' => %w[contentPlaces contentPlace]
          }
          repeats_transforms = {
            'contentplacelocal' => { 'authority' => %w[placeauthorities place] },
            'contentplacetgn' => { 'authority' => %w[placeauthorities tgn_place] }
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)

          # otherNumberList, otherNumber
          othernumber_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          othernumber_transforms = {
            'numbertype' => { 'vocab' => 'numbertype' }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            othernumber_data,
            othernumber_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )

          opp_data = {
            'objectproductionplacelocal' => 'objectProductionPlace',
            'objectproductionplacetgn' => 'objectProductionPlace',
            'objectproductionrole' => 'objectProductionRole'
          }
          opp_transforms = {
            'objectproductionplacelocal' => { 'authority' => %w[placeauthorities place] },
            'objectproductionplacetgn' => { 'authority' => %w[placeauthorities tgn_place] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPlace',
            opp_data,
            opp_transforms,
            list_suffix: 'GroupList',
            group_suffix: 'Group'
          )

          assoc_data = {
            'assocplacelocal' => 'assocPlace',
            'assocplacetgn' => 'assocPlace',
            'assocrole' => 'assocRole'
          }
          assoc_transforms = {
            'assocplacelocal' => { 'authority' => %w[placeauthorities place] },
            'assocplacetgn' => { 'authority' => %w[placeauthorities tgn_place] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPlace',
            assoc_data,
            assoc_transforms,
            list_suffix: 'GroupList',
            group_suffix: 'Group'
          )
        end
      end # class LhmcCollectionObject
    end # module Lhmc
  end # module Converter
end # module CollectionSpace

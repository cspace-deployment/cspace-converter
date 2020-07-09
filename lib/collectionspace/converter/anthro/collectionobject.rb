# frozen_string_literal: true

require_relative '../core/collectionobject'

module CollectionSpace
  module Converter
    module Anthro
      class AnthroCollectionObject < CoreCollectionObject
        ::AnthroCollectionObject = CollectionSpace::Converter::Anthro::AnthroCollectionObject
        include Annotation
        include CulturalCare
        include Locality
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            'objectproductionpeople',
            'objectproductionpeoplerole'
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
              'ns2:collectionobjects_culturalcare',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/domain/culturalcare',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_cultural_care(xml, attributes)
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
          end
        end

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))

          opp_data = {
            'objectproductionpeopleethnoculture' => 'objectProductionPeople',
            'objectproductionpeoplearchculture' => 'objectProductionPeople',
            'objectproductionpeoplerole' => 'objectProductionPeopleRole'
          }
          opp_transforms = {
            'objectproductionpeopleethnoculture' => { 'authority' => %w[conceptauthorities ethculture] },
            'objectproductionpeoplearchculture' => { 'authority' => %w[conceptauthorities archculture] },
            'objectproductionpeoplerole' => { 'vocab' => 'prodpeoplerole' }
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'objectProductionPeople',
            opp_data,
            opp_transforms
          )
        end

        def map_anthro(xml, attributes)
          # locality extension called here because it gets nested in the same namespace with
          #   the rest of the anthro fields
          map_locality(xml, attributes)
          
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # commingledRemainsGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          commingled_remains_data = {
            'agerange' => 'ageRange',
            'behrensmeyerupper' => 'behrensmeyerUpper',
            'behrensmeyersinglelower' => 'behrensmeyerSingleLower',
            'commingledremainsnote' => 'commingledRemainsNote',
            'commingledremainssex' => 'sex',
            'count' => 'count',
            'minindividuals' => 'minIndividuals',
            'dentition' => 'dentition',
            'bone' => 'bone',
            'mortuarytreatment' => 'mortuaryTreatment',
            'mortuarytreatmentnote' => 'mortuaryTreatmentNote'
          }
          mortuary_treatment_fields = %w[
            mortuaryTreatment
            mortuaryTreatmentNote
          ]

          commingled_transforms = {
            'agerange' => { 'replace' => [{ 'find' => ' - ',
                                            'replace' => '-',
                                            'type' => 'plain' }],
                            'vocab' => 'agerange' },
            'behrensmeyerupper' => { 'special' => 'behrensmeyer_translate',
                                     'vocab' => 'behrensmeyer' },
            'behrensmeyersinglelower' => { 'special' => 'behrensmeyer_translate',
                                           'vocab' => 'behrensmeyer' },
            'dentition' => { 'special' => 'boolean' },
            'mortuarytreatment' => { 'vocab' => 'mortuarytreatment' }
          }

          CSXML.add_nested_group_lists(
            xml, attributes,
            'commingledRemains',
            commingled_remains_data,
            'mortuaryTreatment',
            mortuary_treatment_fields,
            commingled_transforms,
            sublist_suffix: 'GroupList',
            subgroup_suffix: 'Group'
          )
        end

        def map_nagpra(xml, attributes)
          pairs = {
            'nagprareportfiled' => 'nagpraReportFiled',
            'nagprareportfiledby' => 'nagpraReportFiledBy'
          }
          pair_transforms = {
            'nagprareportfiled' => { 'special' => 'boolean' },
            'nagprareportfiledby' => { 'authority' => %w[personauthorities person] }
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          repeats = {
            'repatriationnote' => %w[repatriationNotes repatriationNote],
            'nagpracategory' => %w[nagpraCategories nagpraCategory]
          }
          repeat_transforms = {
            'nagpracategory' => { 'vocab' => 'nagpracategory' }
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          CSXML::Helpers.add_date_group(
            xml, 'nagpraReportFiledDate', CSDTP.parse(attributes['nagprareportfileddate']), ''
          )
        end
      end
    end
  end
end

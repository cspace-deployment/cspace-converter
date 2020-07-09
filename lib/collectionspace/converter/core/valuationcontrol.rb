module CollectionSpace
  module Converter
    module Core
      class CoreValuationControl < ValuationControl
        ::CoreValuationControl = CollectionSpace::Converter::Core::CoreValuationControl
        def convert
          run do |xml|
            CoreValuationControl.map_common(xml, attributes)
          end
        end

        def self.map_common(xml, attributes)
          pairs = {
            'valuationcontrolrefnumber' => 'valuationcontrolRefNumber',
            'valuedate' => 'valueDate',
            'valuenote' => 'valueNote',
            'valuerenewaldate' => 'valueRenewalDate',
            'valuetype' => 'valueType',
            'valuesourceorganization' => 'valueSource',
            'valuesourceperson' => 'valueSource',
          }
          pairstransforms = {
            'valuedate' => {'special' => 'unstructured_date_stamp'},
            'valuerenewaldate' => {'special' => 'unstructured_date_stamp'},
            'valuesourceorganization' => {'authority' => ['orgauthorities', 'organization']},
            'valuesourceperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          #valueAmountsList, valueAmounts
          valueamounts_data = {
            'valuecurrency' => 'valueCurrency',
            'valueamount' => 'valueAmount'
          }
          valueamounts_transforms = {
            'valuecurrency' => {'vocab' => 'currency'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'valueAmounts',
            valueamounts_data,
            valueamounts_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )
        end
      end
    end
  end
end

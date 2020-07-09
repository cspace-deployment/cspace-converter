module CollectionSpace
  module Converter
    module Core
      class CoreConditionCheck < ConditionCheck
        ::CoreConditionCheck = CollectionSpace::Converter::Core::CoreConditionCheck
        def convert
          run do |xml|
            CoreConditionCheck.map_common(xml, attributes)
          end
        end

        def self.map_common(xml, attributes)
          pairs = {
            'conditioncheckrefnumber' => 'conditionCheckRefNumber',
            'conditioncheckassessmentdate' => 'conditionCheckAssessmentDate',
            'conditioncheckmethod' => 'conditionCheckMethod',
            'conditionchecknote' => 'conditionCheckNote',
            'conditioncheckreason' => 'conditionCheckReason',
            'objectauditcategory' => 'objectAuditCategory',
            'conservationtreatmentpriority' => 'conservationTreatmentPriority',
            'nextconditioncheckdate' => 'nextConditionCheckDate',
            'displayrecommendations' => 'displayRecommendations',
            'envrecommendations' => 'envRecommendations',
            'handlingrecommendations' => 'handlingRecommendations',
            'packingrecommendations' => 'packingRecommendations',
            'securityrecommendations' => 'securityRecommendations',
            'specialrequirements' => 'specialRequirements',
            'storagerequirements' => 'storageRequirements',
            'legalrequirements' => 'legalRequirements',
            'conditioncheckerperson' => 'conditionChecker',
            'conditioncheckerorganization' => 'conditionChecker'
          }
          pairstransforms = {
            'conditioncheckassessmentdate' => {'special' => 'unstructured_date_stamp'},
            'nextconditioncheckdate' => {'special' => 'unstructured_date_stamp'},
            'conditioncheckerperson' => {'authority' => ['personauthorities', 'person']},
            'conditioncheckerorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)       
          #completenessGroupList, completenessGroup
          overall_completeness = {
            'completeness' => 'completeness',
            'completenessnote' => 'completenessNote',
            'completenessdate' => 'completenessDate'
          }

          completenesstransforms = {
            'completenessdate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'completeness',
            overall_completeness,
            completenesstransforms
          )
          #conditionCheckGroupList, conditionCheckGroup
          overall_condition = {
            'condition' => 'condition',
            'conditionnote' => 'conditionNote',
            'conditiondate' => 'conditionDate'
          }

          conditiontransforms = {
            'conditiondate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'conditionCheck',
            overall_condition,
            conditiontransforms
          )
          #envConditionNoteGroupList, envConditionNoteGroup
          overall_env = {
            'envconditionnote' => 'envConditionNote',
            'envconditionnotedate' => 'envConditionNoteDate'
          }

          envtransforms = {
            'envconditionnotedate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'envConditionNote',
            overall_env,
            envtransforms
          )
          #techAssessmentGroupList, techAssessmentGroup
          overall_tech = {
            'techassessment' => 'techAssessment',
            'techassessmentdate' => 'techAssessmentDate'
          }

          techtransforms = {
            'techassessmentdate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'techAssessment',
            overall_tech,
            techtransforms
          )
          #hazardGroupList, hazardGroup
          overall_hazard = {
            'hazard' => 'hazard',
            'hazarddate' => 'hazardDate',
            'hazardnote' => 'hazardNote'
          }

          hazardtransforms = {
            'hazarddate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'hazard',
            overall_hazard,
            hazardtransforms
          )
          #salvagePriorityCodeGroupList, salvagePriorityCodeGroup
          overall_salvage = {
            'salvageprioritycode' => 'salvagePriorityCode',
            'salvageprioritycodedate' => 'salvagePriorityCodeDate'
          }

          salvagetransforms = {
            'salvageprioritycodedate' => {'special' => 'unstructured_date_stamp'}
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'salvagePriorityCode',
            overall_salvage,
            salvagetransforms
          )
          #legalReqsHeldGroupList, legalReqsHeldGroup
          overall_legal = {
            'legalreqsheld' => 'legalReqsHeld',
            'legalreqsheldbegindate' => 'legalReqsHeldBeginDate',
            'legalreqsheldenddate' => 'legalReqsHeldEndDate',
            'legalreqsheldrenewdate' => 'legalReqsHeldRenewDate',
            'legalreqsheldnumber' => 'legalReqsHeldNumber'
          }

          legaltransforms = {
            'legalreqsheldbegindate' => {'special' => 'unstructured_date_stamp'},
            'legalreqsheldenddate' => {'special' => 'unstructured_date_stamp'},
            'legalreqsheldrenewdate' => {'special' => 'unstructured_date_stamp'},
          }

          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'legalReqsHeld',
            overall_legal,
            legaltransforms
          )
        end
      end
    end
  end
end

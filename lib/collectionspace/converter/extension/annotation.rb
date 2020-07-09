# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      module Annotation
        ::Annotation = CollectionSpace::Converter::Extension::Annotation

        def map_annotation(xml, attributes)
          # annotationGroupList, annotationGroup
          annotation_data = {
            'annotationnote' => 'annotationNote',
            'annotationtype' => 'annotationType',
            'annotationdate' => 'annotationDate',
            'annotationauthor' => 'annotationAuthor'
          }

          annotation_transforms = {
            'annotationauthor' => { 'authority' => %w[personauthorities person] },
            'annotationtype' => { 'vocab' => 'annotationtype' },
            'annotationdate' => { 'special' => 'unstructured_date_stamp' }
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'annotation',
            annotation_data,
            annotation_transforms
          )
        end
      end
    end
  end
end

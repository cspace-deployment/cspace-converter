require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::Annotation do
  let(:attributes) { get_attributes('extension', 'annotation.csv') }
  let(:co) { AnthroCollectionObject.new(attributes) }
  let(:doc) { get_doc(co) }
  let(:record) { get_fixture('ext_annotation.xml') }

  describe 'map_annotation' do
    ns = 'collectionobjects_annotation'
    

    context 'authority/vocab fields' do
      [
        "/document/#{ns}/annotationGroupList/annotationGroup/annotationAuthor",
        "/document/#{ns}/annotationGroupList/annotationGroup/annotationType"
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

    context 'regular fields' do
        [
          "/document/#{ns}/annotationGroupList/annotationGroup/annotationNote",
          "/document/#{ns}/annotationGroupList/annotationGroup/annotationDate",
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

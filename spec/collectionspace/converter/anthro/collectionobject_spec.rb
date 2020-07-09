require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
  let(:anthrocollectionobject) { AnthroCollectionObject.new(attributes) }
  let(:doc) { get_doc(anthrocollectionobject) }
  let(:record) { get_fixture('anthro_collectionobject_2.xml') }

  describe '#map_common' do
    common = 'collectionobjects_common'

    context 'authority/vocab fields' do
      [
        "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeople",
        "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeopleRole"
      ].each do |xpath|
        context xpath.to_s do
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
  end

  describe '#map_anthro' do
    anthro = 'collectionobjects_anthro'

    context 'authority/vocab fields' do
      [
        "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/ageRange",
        "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/behrensmeyerSingleLower",
        "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/behrensmeyerUpper",
        "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/behrensmeyerUpper",
        "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatmentGroup/mortuaryTreatment"
      ].each do |xpath|
        context xpath.to_s do
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
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/commingledRemainsNote",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/sex",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/count",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/minIndividuals",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/dentition",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/bone",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatmentGroup/mortuaryTreatmentNote"
        ].each do |xpath|
          context xpath.to_s do
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

  describe '#map_nagpra' do
    nagpra = 'collectionobjects_nagpra'
    
    context 'authority/vocab fields' do
      [
        "/document/#{nagpra}/nagpraReportFiledBy",
        "/document/#{nagpra}/nagpraCategories/nagpraCategory"
      ].each do |xpath|
        context xpath.to_s do
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
        "/document/#{nagpra}/nagpraReportFiledDate"
      ].each do |xpath|
        context xpath.to_s do
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
        "/document/#{nagpra}/nagpraReportFiled",
        "/document/#{nagpra}/repatriationNotes/repatriationNote"
      ].each do |xpath|
        context xpath.to_s do
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

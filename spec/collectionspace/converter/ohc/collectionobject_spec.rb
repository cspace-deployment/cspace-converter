require 'rails_helper'

RSpec.describe CollectionSpace::Converter::OHC::OHCCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'cspace.ohiohistory.org'
  end

  let(:common) { 'collectionobjects_common' }
  let(:nagpra) { 'collectionobjects_nagpra' }
  let(:anthro) { 'collectionobjects_anthro' }
  let(:annotation) { 'collectionobjects_annotation' }
  let(:ohc) { 'collectionobjects_ohc' }

  describe '#map' do
    context 'sample data row 2' do
      let(:attributes) { get_attributes('ohc', 'collectionobject_ohc_specific.csv') }
      let(:ohccollectionobject) { OHCCollectionObject.new(attributes) }
      let(:doc) { get_doc(ohccollectionobject) }
      let(:record) { get_fixture('ohc_collectionobject_row2.xml') }

      

      it "Maps OHC-specific fields correctly" do
        xpaths = [
          "/document/#{ohc}/descriptionLevel",
          { xpath: "/document/#{ohc}/namedTimePeriods/namedTimePeriod[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/namedTimePeriods/namedTimePeriod[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup[1]/oaiCollectionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup[2]/oaiCollectionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup/oaiLocVerbatim"
        ]
        test_converter(doc, record, xpaths)
      end


      it "Remaps objectNameGroups correctly" do
        xpaths = [
          "/document/#{common}/objectNameList/objectNameGroup/objectNameType",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameSystem",
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[1]/objectName", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[2]/objectName", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{common}/objectNameList/objectNameGroup/objectNameCurrency",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameNote",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameLevel",
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[1]/objectNameLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[2]/objectNameLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        ]
        test_converter(doc, record, xpaths)
      end

      it "Remaps assocPeopleGroups correctly" do
        xpaths = [
          "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleNote",
          "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleType",
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
        ]
        test_converter(doc, record, xpaths)
      end
    end #  context 'sample data row 2'
  end # describe #map


  context 'all OHC skeletal fields (integration)' do
    let(:attributes) { get_attributes('ohc', 'collectionobject_remains.csv') }
    let(:ohccollectionobject) { OHCCollectionObject.new(attributes) }
    let(:doc) { get_doc(ohccollectionobject) }
    let(:record) { get_fixture('ohc_collectionobject_full.xml') }

    let(:xpaths) {[
      { xpath: "/document/#{common}/objectNameList/objectNameGroup[1]/objectName", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{common}/objectNameList/objectNameGroup[2]/objectName", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{common}/responsibleDepartments/responsibleDepartment",
      "/document/#{common}/objectNumber",
      "/document/#{common}/fieldCollectionFeature",
      "/document/#{common}/otherNumberList/otherNumber[1]/numberValue",
      "/document/#{common}/otherNumberList/otherNumber[2]/numberValue",
      "/document/#{common}/otherNumberList/otherNumber[1]/numberType",
      "/document/#{common}/otherNumberList/otherNumber[2]/numberType",
      { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[1]/objectProductionPeople", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[1]/objectProductionPeopleRole", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeople", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeopleRole", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleType",
      { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
      { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
      "/document/#{common}/collection",
      "/document/#{common}/objectProductionNote",
      { xpath: "/document/#{common}/publishToList/publishTo",  transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{common}/comments/comment",
      { xpath: "/document/#{common}/inventoryStatusList/inventoryStatus[1]",  transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{common}/inventoryStatusList/inventoryStatus[2]",  transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{annotation}/annotationGroupList/annotationGroup/annotationNote",
      { xpath: "/document/#{annotation}/annotationGroupList/annotationGroup[1]/annotationType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{nagpra}/nagpraReportFiled",
      { xpath: "/document/#{nagpra}/nagpraReportFiledBy", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{nagpra}/repatriationNotes/repatriationNote",
      { xpath: "/document/#{nagpra}/nagpraCategories/nagpraCategory[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{nagpra}/nagpraCategories/nagpraCategory[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{nagpra}/nagpraReportFiledDate/dateLatestScalarValue",
      "/document/#{nagpra}/nagpraReportFiledDate/dateEarliestScalarValue",
      { xpath: "/document/#{anthro}/localityGroupList/localityGroup/fieldLocPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{anthro}/localityGroupList/localityGroup/fieldLocCounty",
      "/document/#{anthro}/localityGroupList/localityGroup/fieldLocState",
      "/document/#{anthro}/localityGroupList/localityGroup/localityNote",
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/ageRange", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/ageRange", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/behrensmeyerUpper", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/behrensmeyerUpper", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/behrensmeyerSingleLower", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/behrensmeyerSingleLower", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/minIndividuals",
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[1]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[1]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatmentGroup/mortuaryTreatmentNote"
    ]}

    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

end

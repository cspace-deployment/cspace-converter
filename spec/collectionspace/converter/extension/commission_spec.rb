require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::Commission do
  let(:attributes) { get_attributes('publicart', 'acquisition_publicart.csv') }
  let(:acq) { PublicArtAcquisition.new(attributes) }
  let(:doc) { get_doc(acq) }
  let(:record) { get_fixture('publicart_acquisition.xml') }

  describe 'map_commission' do
    ac = 'acquisitions_commission'
    context 'non-authority/vocab fields' do
      [
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionActualValueAmount",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionProjectedValueAmount",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionBudgetTypeNote",
      ].each do |xpath|
        context xpath.to_s do
          let(:docval) { get_text(doc, xpath) }
          it 'is not empty' do
            expect(docval).to_not be_empty
          end
          
          it 'matches sample payload' do
            expect(docval).to eq(get_text(record, xpath))
          end
        end
      end
    end

    context 'structured date fields' do
      [
        "/document/#{ac}/commissionDate"
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

    context 'authority/vocab fields' do
      [
        "/document/#{ac}/commissioningBodyList/commissioningBody",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionProjectedValueCurrency",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionActualValueCurrency",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionBudgetType"
      ].each do |xpath|
        context xpath.to_s do
          let(:docurns) { urn_values(doc, xpath) }
          it 'is not empty' do
            expect(get_text(doc, xpath)).not_to be_empty
          end

          it 'values are URNs' do
            expect(docurns).not_to include('not a urn')
          end
          
          it 'URNs match sample payload' do
            expect(docurns).to eq(urn_values(record, xpath))
          end
        end
      end      
    end
  end
end


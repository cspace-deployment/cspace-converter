require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::SocialMedia do
  let(:attributes) { get_attributes('publicart', 'Org_auth_publicart.csv') }
  let(:publicartorganization) { PublicArtOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(publicartorganization) }
  let(:record) { get_fixture('publicart_organization.xml') }

  describe 'map_social_media' do
    # starring out namespace, since fields from this extension get put into
    #  persons_publicart, organizations_publicart, or wherever they get used. 
    context 'text field' do
      [
        "/document/*/socialMediaGroupList/socialMediaGroup/socialMediaHandle"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'matches sample payload' do
            expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
          end
        end
      end
    end

      context 'vocab field' do
      [
        "/document/*/socialMediaGroupList/socialMediaGroup/socialMediaHandleType"
      ].each do |xpath|
        context xpath.to_s do
          it 'all values will be URNs' do
            expect(urn_values(doc, xpath)).not_to include('Not a URN')
          end
          
          it 'URNs match sample payload' do
            expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
          end
        end
      end
      end
    end
  end

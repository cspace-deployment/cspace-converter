# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthCache do
  before(:all) do
    Rails.configuration.refcache.put(
      'orgauthorities', 'organization', 'Barnes Foundation',
      "urn:cspace:core.collectionspace.org:orgauthorities:name(organization):item:name(BarnesFoundation1542642516661)'Barnes Foundation'"
    )
    Rails.configuration.refcache.put(
      'vocabularies', 'languages', 'English',
      "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(eng)'English'"
    )
  end

  after(:all) do
    sleep 1
    Rails.configuration.refcache.clean
  end

  it 'can load and retrieve cache objects' do
    # cache_object_authority.save
    expect(
      AuthCache.authority('orgauthorities', 'organization', 'Barnes Foundation')
    ).to eq 'BarnesFoundation1542642516661'
  end

  it 'can add to and retrieve vocabularies from the cache' do
    # cache_object_vocabulary.save
    expect(
      AuthCache.vocabulary('languages', 'English')
    ).to eq 'eng'
  end
end

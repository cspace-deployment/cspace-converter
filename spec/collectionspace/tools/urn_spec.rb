# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSURN do
  let(:vocab_urn) do
    "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'"
  end

  let(:urn_with_colon_in_name) do
    "urn:cspace:core.collectionspace.org:locationauthorities:name(location):item:name(AR1U1Shelf14078111602)'A:R1:U1:Shelf 1'"
  end

  it 'can generate vocabulary urn when not in cache' do
    expect(
      CSURN.get_vocab_urn('languages', 'English')
    ).to eq vocab_urn
  end

  it 'can parse a vocabulary refname' do
    parsed_urn = CSURN.parse(vocab_urn)
    expect(parsed_urn[:domain]).to eq 'core.collectionspace.org'
    expect(parsed_urn[:type]).to eq 'vocabularies'
    expect(parsed_urn[:subtype]).to eq 'languages'
    expect(parsed_urn[:identifier]).to eq 'english'
    expect(parsed_urn[:label]).to eq 'English'
  end

  it 'can parse a urn that contains colons in the name' do
    parsed_urn = CSURN.parse(urn_with_colon_in_name)
    expect(parsed_urn[:domain]).to eq 'core.collectionspace.org'
    expect(parsed_urn[:type]).to eq 'locationauthorities'
    expect(parsed_urn[:subtype]).to eq 'location'
    expect(parsed_urn[:identifier]).to eq 'AR1U1Shelf14078111602'
    expect(parsed_urn[:label]).to eq 'A:R1:U1:Shelf 1'
  end

  it 'can parse type from vocabulary refname' do
    expect(CSURN.parse_type(vocab_urn)).to eq 'vocabularies'
  end

  it 'can parse subtype from vocabulary refname' do
    expect(CSURN.parse_subtype(vocab_urn)).to eq 'languages'
  end
end

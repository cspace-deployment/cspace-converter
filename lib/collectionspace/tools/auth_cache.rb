# frozen_string_literal: true

module CollectionSpace
  module Tools
    module AuthCache
      ::AuthCache = CollectionSpace::Tools::AuthCache
      # CACHE FORMAT
      # "citationauthorities" "citation" "getty aat" => "getty_att"
      # "acquisition" "acquisitionReferenceNumber" "$id" => "$csid"
      # "vocabularies" "socialmediatype" "facebook" => "facebook"

      def self.fetch(parts)
        refname = Rails.configuration.refcache.get(*parts)
        refname ? CSURN.parse(refname)[:identifier] : nil
      end

      # public accessor to cached authority terms
      def self.authority(authority, authority_subtype, display_name)
        fetch([authority, authority_subtype, display_name])
      end

      # public accessor to cached vocabulary terms
      def self.vocabulary(vocabulary, display_name)
        fetch(['vocabularies', vocabulary, display_name])
      end
    end
  end
end

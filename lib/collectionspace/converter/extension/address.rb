# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      module Address
        ::Address = CollectionSpace::Converter::Extension::Address
        # since this extension gets used in records in both Organization and
        # Person classes, it is not subclassed to a specific record type class

        class AuthorityConfig
          ::AuthorityConfig = CollectionSpace::Converter::Extension::Address::AuthorityConfig
          attr_reader :ids, :data, :idlookup, :transforms
          def initialize(authorities)
            @fields = %w[addressMunicipality addressStateOrProvince addressCountry]
            @idlookup = {
              'local' => 'place',
              'tgn' => 'tgn_place',
              'shared' => 'place_shared'
            }
            @ids = authorities.map{ |a| a.split('/')[1] }
            @data = get_data
            @transforms = get_transforms
          end

          private

          def get_data
            config = {}
            @ids.each do |id|
              @fields.each{ |f| config["#{f.downcase}#{id}"] = f }
            end
            config
          end

          def get_transforms
            config = {}
            @ids.each do |id|
              @fields.each do |f|
                val = {'authority' => ['placeauthorities', @idlookup[id]]}
                config["#{f.downcase}#{id}"] = val
              end
            end
            config
          end
        end
                
        def self.map_address(xml, attributes, place_authorities)
          auth_config = AuthorityConfig.new(place_authorities)

          #addrGroupList, addrGroup
          address_data = {
            "addressplace2" => "addressPlace2",
            "addressplace1" => "addressPlace1",
            "addresstype" => "addressType",
            "addresspostcode" => "addressPostCode",
          }
          
          address_transforms = {
            'addresstype' => {'vocab' => 'addresstype'},
          }
          
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'addr',
            address_data.merge(auth_config.data),
            address_transforms.merge(auth_config.transforms)
          )
        end
      end
    end
  end
end

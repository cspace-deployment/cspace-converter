module CollectionSpace
  module Converter
    module Default
      ::Default = CollectionSpace::Converter::Default
      class Record
        attr_reader :attributes, :config, :redefined
        def initialize(attributes, config = {})
          @attributes = attributes
          @config = config
          @redefined = []
        end

        # default implementation used by stub authorities / vocabularies
        # overriden by sub-classes, returns converted record
        def convert
          run do |xml|
            map(xml, attributes)
          end
        end

        # default implementation used by stub authorities / vocabularies
        def map(xml, attributes)
          CSXML.add xml, 'shortIdentifier', attributes['shortidentifier']
          CSXML.add_group_list xml, attributes['termtype'], [{
            'termDisplayName' => attributes['termdisplayname'],
          }]
        end

        def redefined_fields
          @redefined.uniq.each_with_object({}) { |k, h| h[k] = nil }
        end

        def run(document, service, common)
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.document(name: document) {
              if common
                xml.send(
                  "ns2:#{document}_common",
                  "xmlns:ns2" => "http://collectionspace.org/services/#{service}",
                  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
                ) do
                  # applying namespace breaks import
                  xml.parent.namespace = nil
                  yield xml
                end
              else
                yield xml # entire document (for extensions)
              end
            }
          end
          traverse_and_clean(builder.doc)
          builder.to_xml.to_s.gsub(/(<\/?)(\w+_)/, '\1ns2:\2')
        end

        def traverse_and_clean(node)
          node.children.map { |child| traverse_and_clean(child) }
          node.remove if node.content.blank? && node.attributes.blank?
        end

        def self.service(subtype = nil)
          raise 'Must be implemented in subclass'
        end
      end

      class Acquisition < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'acquisitions', 'acquisition', common
        end

        def self.service(subtype = nil)
          {
            id: 'acquisitions',
            identifier_field: 'acquisitionReferenceNumber',
            path: 'acquisitions',
            schema: 'acquisitions',
          }
        end
      end

      class Citation < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'citations', 'citation', common
        end

        def self.service(subtype = nil)
          {
            id: 'citationauthorities',
            identifier_field: 'shortIdentifier',
            path: "citationauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'citations',
          }
        end
      end

      class CollectionObject < Record
        ::CollectionObject = CollectionSpace::Converter::Default::CollectionObject
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'collectionobjects', 'collectionobject', common
        end

        def self.service(subtype = nil)
          {
            id: 'collectionobjects',
            identifier_field: 'objectNumber',
            path: 'collectionobjects',
            schema: 'collectionobjects',
          }
        end
      end

      class Concept < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'concepts', 'concept', common
        end

        def self.service(subtype = nil)
          {
            id: 'conceptauthorities',
            identifier_field: 'shortIdentifier',
            path: "conceptauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'concepts',
          }
        end
      end

      class ConditionCheck < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'conditionchecks', 'conditioncheck', common
        end

        def self.service(subtype = nil)
          {
            id: 'conditionchecks',
            identifier_field: 'conditionCheckRefNumber',
            path: 'conditionchecks',
            schema: 'conditionchecks',
          }
        end
      end

      class Conservation < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'conservation', 'conservation', common
        end

        def self.service(subtype = nil)
          {
            id: 'conservation',
            identifier_field: 'conservationNumber',
            path: 'conservation',
            schema: 'conservation',
          }
        end
      end

      class Exhibition < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'exhibitions', 'exhibition', common
        end

        def self.service(subtype = nil)
          {
            id: 'exhibitions',
            identifier_field: 'exhibitionNumber',
            path: 'exhibitions',
            schema: 'exhibitions',
          }
        end
      end

      class Group < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'groups', 'group', common
        end

        def self.service(subtype = nil)
          {
            id: 'groups',
            identifier_field: 'title',
            path: 'groups',
            schema: 'groups',
          }
        end
      end

      class Hierarchy < Record
        # override the default authority convert method inline
        def convert
          run do |xml|
            CSXML.add xml, 'subjectCsid', attributes["subjectcsid"]
            CSXML.add xml, 'subjectDocumentType', attributes["subjectdocumenttype"]
            CSXML.add xml, 'relationshipType', "hasBroader"
            CSXML.add xml, 'predicate', 'hasBroader'
            CSXML.add xml, 'objectCsid', attributes["objectcsid"]
            CSXML.add xml, 'objectDocumentType', attributes["objectdocumenttype"]
          end
        end

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'relations', 'relation', common
        end

        def self.service(subtype = nil)
          {
            id: 'relations',
            identifier_field: 'csid',
            path: 'relations',
            schema: 'relations',
          }
        end
      end

      class Intake < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'intakes', 'intake', common
        end

        def self.service(subtype = nil)
          {
            id: 'intakes',
            identifier_field: 'entryNumber',
            path: 'intakes',
            schema: 'intakes',
          }
        end
      end

      class LoanIn < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'loansin', 'loanin', common
        end

        def self.service(subtype = nil)
          {
            id: 'loansin',
            identifier_field: 'loanInNumber',
            path: 'loansin',
            schema: 'loansin',
          }
        end
      end

      class LoanOut < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'loansout', 'loanout', common
        end

        def self.service(subtype = nil)
          {
            id: 'loansout',
            identifier_field: 'loanOutNumber',
            path: 'loansout',
            schema: 'loansout',
          }
        end
      end

      class Location < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'locations', 'location', common
        end

        def self.service(subtype = nil)
          {
            id: 'locationauthorities',
            identifier_field: 'shortIdentifier',
            path: "locationauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'locations',
          }
        end
      end

      class Material < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'materials', 'material', common
        end

        def self.service(subtype = nil)
          {
            id: 'materialauthorities',
            identifier_field: 'shortIdentifier',
            path: "materialauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'materials',
          }
        end
      end

      class Media < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'media', 'media', common
        end

        def self.service(subtype = nil)
          {
            id: 'media',
            identifier_field: 'identificationNumber',
            path: 'media',
            schema: 'media',
          }
        end
      end

      class Movement < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'movements', 'movement', common
        end

        def self.service(subtype = nil)
          {
            id: 'movements',
            identifier_field: 'movementReferenceNumber',
            path: 'movements',
            schema: 'movements',
          }
        end
      end

      class Nagpra < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'claims', 'claim', common
        end

        def self.service(subtype = nil)
          {
            id: 'claims',
            identifier_field: 'claimNumber',
            path: 'claims',
            schema: 'claims',
          }
        end
      end

      class ObjectExit < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'objectexit', 'objectexit', common
        end

        def self.service(subtype = nil)
          {
            id: 'objectexit',
            identifier_field: 'exitNumber',
            path: 'objectexit',
            schema: 'objectexit',
          }
        end
      end

      class Organization < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'organizations', 'organization', common
        end

        def self.service(subtype = nil)
          {
            id: 'orgauthorities',
            identifier_field: 'shortIdentifier',
            path: "orgauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'organizations',
          }
        end
      end

      class Osteology < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'osteology', 'osteology', common
        end

        def self.service(subtype = nil)
          {
            id: 'osteology',
            identifier_field: 'InventoryID',
            path: 'osteology',
            schema: 'osteology',
          }
        end
      end

      class Person < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'persons', 'person', common
        end

        def self.service(subtype = nil)
          {
            id: 'personauthorities',
            identifier_field: 'shortIdentifier',
            path: "personauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'persons',
          }
        end
      end

      class Place < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'places', 'place', common
        end

        def self.service(subtype = nil)
          {
            id: 'placeauthorities',
            identifier_field: 'shortIdentifier',
            path: "placeauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'places',
          }
        end
      end

      class Work < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'works', 'work', common
        end

        def self.service(subtype = nil)
          {
            id: 'workauthorities',
            identifier_field: 'shortIdentifier',
            path: "workauthorities/urn:cspace:name(#{subtype})/items",
            schema: 'works',
          }
        end
      end

      class Relationship < Record
        # override the default authority convert method inline
        def convert
          run do |xml|
            CSXML.add xml, 'subjectCsid', attributes["subjectcsid"]
            CSXML.add xml, 'subjectDocumentType', attributes["subjectdocumenttype"]
            CSXML.add xml, 'relationshipType', "affects"
            CSXML.add xml, 'predicate', "affects"
            CSXML.add xml, 'objectCsid', attributes["objectcsid"]
            CSXML.add xml, 'objectDocumentType', attributes["objectdocumenttype"]
          end
        end

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'relations', 'relation', common
        end

        def self.service(subtype = nil)
          {
            id: 'relations',
            identifier_field: 'csid',
            path: 'relations',
            schema: 'relations',
          }
        end
      end

      class Taxon < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'taxon', 'taxonomy', common
        end

        def self.service(subtype = nil)
          {
            id: 'taxonomyauthority',
            identifier_field: 'shortIdentifier',
            path: "taxonomyauthority/urn:cspace:name(#{subtype})/items",
            schema: 'taxon',
          }
        end
      end

      class UseOfCollection < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'uoc', 'uoc', common
        end

        def self.service(subtype = nil)
          {
            id: 'uoc',
            identifier_field: 'referenceNumber',
            path: 'uoc',
            schema: 'uoc',
          }
        end
      end

      class ValuationControl < Record
        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'valuationcontrols', 'valuationcontrol', common
        end

        def self.service(subtype = nil)
          {
            id: 'valuationcontrols',
            identifier_field: 'valuationcontrolRefNumber',
            path: 'valuationcontrols',
            schema: 'valuationcontrols',
          }
        end
      end

      class Vocabulary < Record
        # override the default authority convert method inline
        def convert
          run do |xml|
            CSXML.add xml, 'displayName', attributes["displayname"]
            CSXML.add xml, 'shortIdentifier', attributes["shortidentifier"]
          end
        end

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'vocabularyitems', 'vocabulary', common
        end

        def self.service(subtype = nil)
          {
            id: 'vocabularies',
            identifier_field: 'shortIdentifier',
            path: "vocabularies/urn:cspace:name(#{subtype})/items",
            schema: 'vocabularyitems',
          }
        end
      end
    end
  end
end

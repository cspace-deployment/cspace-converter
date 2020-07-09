# Development

## Converters

Converters are (Ruby) modules containing (Ruby) classes and
profiles (config) for mapping data in one or more CSV documents to
CollectionSpace XML records.

```ruby
CollectionSpace::Converter::$MODULE::$CLASS
CollectionSpace::Converter::Core::Collectionobject
```

Module and class names are arbitrary, not related to anything
specifically within CollectionSpace, although in practice there
is a close correlation.

Profiles are defined in a `config.yml` file inside the module
directory:

```bash
lib/collectionspace/converter/core/config.yml
```

More details are provided below.

### How to create a converter

Converters are defined in `lib/collectionspace/converter/`.
This directory containers a `default/record.rb` file that is the
foundation for converter profiles to build upon. If a procedure
or authority is not represented in `record.rb` it cannot be mapped,
and most likely should be added (pull requests are welcome!).

Subfolders in this directory are converter modules. Each
converter requires:

- a `_config.rb` file containing some boilerplate setup
- a `config.yml` file that defines the converter mapping behavior

If you're creating a converter for `mymuseum` you could create:

- `lib/collectionspace/converter/mymuseum/_config.rb`
- `lib/collectionspace/converter/mymuseum/config.yml`

## Converter configuration

Begin by copying the `core/_config.rb` but replace "Default"
with "MyMuseum" (following ruby naming conventions).

```ruby
module CollectionSpace
  module Converter
    module MyMuseum
      include Default
    end
  end
end
```

Next, copy `core/config.yml` and update it as development progresses.

The sections are:

### Registered Authorities

The list of authority record types this converter generates.

### Registered Procedures

This is simply a list of Procedures that this converter can generate
XML records for. It's a handbrake against inadevertently generating
unwanted record types.

### Registered Profiles

This is where the bulk of configuration happens. A converter can
implement one or more profiles. You can name these arbitrarily
according to what makes sense for your data. If all of your data
was in a single spreadsheet if may look like:

```yml
registered_profiles:
  mymuseum:
    # ...
```

This would indicate a single converter "profile" being used to handle
a **single** CSV document. There should only be one profile per CSV file,
but one profile can handle multiple record types per CSV.

If we have multiple CSV files to work with we'll need multiple
"profiles":

```yml
registered_profiles:
  cataloging:
    # ...
  media:
    # ...
```

In this case there are distinct CSV files for different procedures
so we need a profile to manage each data file.

Each "profile" needs to define the type of records it generates from
the CSV data:

#### Procedures

Each Procedure to be generated using this profile needs an entry
defining:

- identifier: the field in the source data used for identifier_field
- title: the field in the source data used for the local title

Note: the CSV processor downcases all characters and replaces spaces
with "_". So a field like "ID Number" should be referred to
as "id_number" within the application.

Example:

```yml
acquisition:
  type: Procedures
  enabled: true # make availabe in the ui
  required_headers:
    - acquisitionreferencenumber
  config:
    Acquisition:
      identifier: acquisitionreferencenumber
      title: acquisitionreferencenumber
cataloging:
  type: Procedures
  enabled: false # disabled in the ui
  required_headers:
    - objectnumber
  config:
    CollectionObject:
      identifier: objectnumber
      title: objectnumber
```

The Procedures configuration can include an "Authorities" key. This refers
to fields within the csv that refer to, and can generate, authority records
directly related to the procedures:

```yml
acquisition:
  type: Procedures
  config:
    # ...
    Authorities:
      - name_field: acquisitionauthorizer
        authority_type: Person
        authority_subtype: person
      - name_field: ownerPerson
        authority_type: Person
        authority_subtype: person
      - name_field: ownerOrganization
        authority_type: Organization
        authority_subtype: organization
cataloging:
  type: Procedures
  config:
    # ...
    Authorities:
      - name_field: contentperson
        authority_type: Person
        authority_subtype: person
      - name_field: inscriber
        authority_type: Person
        authority_subtype: person
      - name_field: productionperson
        authority_type: Person
        authority_subtype: person
      - name_field: productionorg
        authority_type: Organization
        authority_subtype: organization
```

#### Authorities

Each Authority to be generated using this profile needs an entry
defining:

- name_field: field used to generate the authority name / short_id
- authority_type: the primary authority type i.e. Concept, Person etc.
- authority_subtype: the authority subtype i.e. person, ulan_pa, person_shared

Example:

```yml
person:
  type: Authorities
  config:
    name_field: termdisplayname
    authority_type: Person
    authority_subtype: person
```

## Running a converter

```bash
./import.sh data/mymuseum/mymuseum_data.csv mymuseum1 mymuseum
```

The arguments correspond to:

- csv name
- batch name (arbitrary)
- converter profile

---

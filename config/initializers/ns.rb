# frozen_string_literal: true

require 'rdf'
require 'rdf/vocab'

class NS < LinkedRails::Vocab
  register_strict(dc)
  register_strict(org)
  register(:argu, 'https://argu.co/ns/core#')
  register(:dex, 'https://dexpods.eu/ns/core#')
  register(:dcat, 'http://www.w3.org/ns/dcat#')
  register(:donl, 'https://data.overheid.nl/dcat.rdf#')
  register(:space, 'http://www.w3.org/ns/pim/space#')

  register(:adms, 'http://www.w3.org/ns/adms#')

  app_vocabulary :dex
end

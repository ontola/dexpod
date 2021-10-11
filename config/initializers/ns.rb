# frozen_string_literal: true

require 'rdf'
require 'rdf/vocab'

class NS < LinkedRails::Vocab
  register_strict(dc)
  register_strict(org)
  register(:argu, 'https://argu.co/ns/core#')
  register(:dex, 'https://argu.co/ns/dex#')
  register(:dcat, 'http://www.w3.org/ns/dcat#')
  register(:donl, 'https://data.overheid.nl/dcat.rdf#')

  register(:adms, 'http://www.w3.org/ns/adms#')

  app_vocabulary :dex
end

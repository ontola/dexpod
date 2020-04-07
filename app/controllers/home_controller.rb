# frozen_string_literal: true

class HomeController < ApplicationController
  active_response :show

  def show_success
    respond_with_resource resource: website, include: LinkedRails::WebSite.show_includes
  end

  private

  def homepage
    LinkedRails::WebPage.new(
      name: 'Dexes',
      description: 'Welkom!',
      includes: homepage_includes,
      iri: LinkedRails.iri(path: 'home')
    )
  end

  def homepage_includes
    []
  end

  def website
    LinkedRails::WebSite.new(
      homepage: homepage,
      image: RDF::URI('http://fontawesome.io/icon/home'),
      iri: LinkedRails.iri,
      name: 'Dexes',
      # navigations_menu: AppMenuList.new(resource: current_user).menu(:navigations).iri
    )
  end
end

# frozen_string_literal: true

# Base homepage controller
class HomePageController < ApplicationController
  active_response :show

  def show_success
    respond_with_resource resource: website,
                          include: LinkedRails::WebSite.show_includes
  end

  private

  def homepage
    const_get(:HomePage).new(
      name: current_manifest.site_name.capitalize,
      description: welcome_text,
      includes: homepage_includes,
      iri: LinkedRails.iri(path: 'home'),
      widgets: homepage_widgets
    )
  end

  def homepage_includes
    homepage_widgets
  end

  def homepage_widgets
    []
  end

  def website
    LinkedRails::WebSite.new(
      homepage: homepage,
      image: RDF::URI('http://fontawesome.io/icon/home'),
      iri: LinkedRails.iri,
      name: current_manifest.site_name.capitalize,
      navigations_menu: AppMenuList.new(resource: current_user).menu(:navigations).iri
    )
  end
end

# frozen_string_literal: true

class SessionActionList < LinkedRails.action_list_parent_class
  def self.actionable_class
    Session
  end

  has_singular_create_action(
    policy: :create?,
    root_relative_iri: lambda {
      uri = resource.root_relative_iri.dup
      uri.path ||= ''
      uri.path += '/new'
      uri.query = {redirect_url: resource.redirect_url}.compact.to_param.presence
      uri.to_s
    },
    type: [NS.ontola['Create::Auth::Session'], RDF::Vocab::SCHEMA.CreateAction]
  )
end

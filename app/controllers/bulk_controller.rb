# frozen_string_literal: true

class BulkController < LinkedRails::BulkController
  private

  def handle_resource_error(_opts, error)
    Bugsnag.notify(error)

    super
  end

  def resource_body(resource) # rubocop:disable Metrics/MethodLength
    return if resource.nil?

    RDF::Serializers
      .serializer_for(resource)
      .new(
        resource,
        include: resource&.class.try(:preview_includes),
        params: {
          scope: user_context,
          context: resource&.try(:iri)
        }
      )
      .send(:render_hndjson)
  end

  def response_for_wrong_host(opts)
    return super unless self.class.external_resources.key?(opts[:iri])

    resource = self.class.external_resources[opts[:iri]]

    resource_response(
      resource.iri,
      body: opts[:include].to_s == 'true' ? resource_body(resource) : nil,
      cache: :public,
      language: I18n.locale,
      status: 200
    )
  end

  class << self
    def external_resources
      @external_resources ||=
        ApplicationSerializer
          .descendants
          .map { |serializer| serializer._enums&.values&.map(&:values) || [] }
          .flatten
          .reject { |option| option.iri.host == LinkedRails.iri.host }
          .index_by { |option| option.iri.to_s }
    end
  end
end

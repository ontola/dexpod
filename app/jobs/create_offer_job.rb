# frozen_string_literal: true

class CreateOfferJob < ApplicationJob
  attr_accessor :distribution

  def perform(distribution_id)
    if !broker_url
      Rails.logger.error('No broker URL present')
      return
    end

    self.distribution = Distribution.find_by(id: distribution_id)
    create_offer
  end

  private

  def create_offer
    return if distribution.blank?

    offer_iri = DexBroker.create_offer(body)

    distribution.update(offer_iri: offer_iri)
  end

  def body
    {
      dataOwner: distribution.user.dex_identity&.identifier,
      resource: distribution.node&.iri,
      scope: '',
      conditions: [
        {
          text: distribution.description,
          type: :ExplicitDisclaimerCondition
        }
      ],
      permitted: :permit,
      recipient: 'https://thom.dexpods.eu'
    }
  end
end

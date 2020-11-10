# frozen_string_literal: true

class AgreementBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id)
    return unless ENV['SEED_BROKERS']

    agreement = Agreement.find(id)

    KafkaBroadcaster.produce_agreement(agreement)
  end
end

# frozen_string_literal: true

class DatasetBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id)
    return unless ENV['SEED_BROKERS']

    dataset = Dataset.find(id)

    KafkaBroadcaster.produce_dataset(dataset)
  end
end

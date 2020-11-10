# frozen_string_literal: true

class KafkaBroadcaster
  class << self
    AGREEMENT_TOPIC = 'agreement'

    def client
      @client ||= Kafka.new(
        logger: Rails.logger,
        sasl_plain_password: ENV['SASL_PASSWORD'],
        sasl_plain_username: ENV['SASL_USERNAME'],
        seed_brokers: ENV['SEED_BROKERS'],
        ssl_ca_certs_from_system: true
      )
    end

    def produce_agreement(agreement)
      producer.produce(
        AgreementSerializer.new(agreement).dump(:hndjson),
        key: agreement.iri,
        topic: AGREEMENT_TOPIC
      )
    end

    def producer
      @producer ||= client.async_producer(
        delivery_interval: 10
      )
    end

    def shutdown
      @producer&.shutdown
    end
  end
end

at_exit do
  KafkaBroadcaster.shutdown
end

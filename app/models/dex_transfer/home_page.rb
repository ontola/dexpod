# frozen_string_literal: true

module DexTransfer
  class HomePage < ::HomePage
    enhance LinkedRails::Enhancements::Actionable

    attr_writer :widgets
    attr_accessor :cover_photo, :includes, :hide_header

    def transfer_action
      Offer.root_collection.action(:create)
    end

    def widget_sequence
      @widget_sequence ||= LinkedRails::Sequence.new(@widgets) if @widgets
    end

    class << self
      def iri
        NS::DEX[:HomePage]
      end

      def show_includes
        super + [:includes, widget_sequence: {members: LinkedRails::Widget.show_includes}]
      end
    end
  end
end

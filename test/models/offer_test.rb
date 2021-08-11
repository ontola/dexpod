# frozen_string_literal: true

require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  let(:pod) { create(:pod, web_id: build(:web_id)) }
  let(:user) { create(:user) }

  test 'offer accepts node attributes' do
    offer = Offer.new(
      user: user,
      node: pod.root_node,
      node_attributes: {
        title: 'my node'
      }
    )

    assert_equal 'my node', offer.node.title
  end
end

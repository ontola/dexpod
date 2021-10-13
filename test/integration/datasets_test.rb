# frozen_string_literal: true

require 'test_helper'

class DatasetsTest < ActionDispatch::IntegrationTest
  define_pod
  let(:node) { create(:node, parent: pod.root_node) }
  let(:dataset) { create(:dataset) }
  let!(:distribution) { create(:distribution, dataset: dataset, node: node) }

  ####################################
  # As Guest
  ####################################
  test 'should get dataset with included distributions' do
    get resource_iri(dataset, pod), headers: request_headers

    assert_response :success

    expect_resource_type(NS.dex[:Dataset], iri: resource_iri(dataset, pod))
    expect_resource_type(NS.dex[:Distribution], iri: resource_iri(distribution, pod))
  end
end

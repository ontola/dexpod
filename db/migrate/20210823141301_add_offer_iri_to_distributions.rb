class AddOfferIriToDistributions < ActiveRecord::Migration[6.1]
  def change
    add_column :distributions, :offer_iri, :string
  end
end

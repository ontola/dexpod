load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])

Apartment::Tenant.drop('user') if ApplicationRecord.connection.schema_exists?('user')
Pod.find_by(pod_name: 'user')&.destroy
WebId.find_by(email: 'user@example.com')&.destroy
Pod.create!(
  pod_name: 'user',
  theme_color: '#333333',
  web_id: WebId.new(
    email: 'user@example.com',
    password: 'password'
  )
)
Apartment::Tenant.switch!('user')

def define_pod
  let(:pod) { Pod.find_by!(pod_name: 'user') }
  let(:web_id) { WebId.find_by!(email: 'user@example.com') }
end

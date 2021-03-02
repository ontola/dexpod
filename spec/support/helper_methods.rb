# frozen_string_literal: true

module HelperMethods # rubocop:disable Metrics/ModuleLength
  ALLOWED_HOSTS = [
    'https://chromedriver.storage.googleapis.com',
    /bugsnag.com/,
    'https://user.dexpods.localdev',
    'https://dexpods.localdev',
    'https://dextransfer.localdev'
  ].freeze

  def application_menu
    wait_for { page }.to have_css('.AppMenu')
    page.find('.AppMenu')
  end

  def application_menu_button
    wait_for { page }.to have_button(text: 'Menu')
    page.find(:button, text: 'Menu')
  end

  def click_application_menu_button(button)
    application_menu_button.click
    wait_until_loaded
    wait_for { page }.to have_css '.AppMenu'
    wait_for { application_menu }.to have_content button
    sleep 1
    within application_menu do
      click_link button
    end
  end

  def click_navbar_item(item)
    wait_for(page).to have_css 'header.MuiAppBar-root'
    within 'header.MuiAppBar-root' do
      click_link item
    end
    wait_until_loaded
  end

  def click_menu_item(text, menu: :actions, resource: page.current_url)
    wait_until_loaded
    resource_selector("#{resource}/menus/#{menu}").click
    wait_until_loaded
    yield if block_given?
    wait_for(page).to have_css('.MuiListItem-button', text: text)
    sleep(1)
    find('.MuiListItem-button', text: text).click
  end

  def field_name(*names)
    names.map { |name| name.is_a?(String) ? Base64.encode64(name).gsub("\n", '') : name }.join('.')
  end

  def fill_in_login_form(email, password = 'password') # rubocop:disable Metrics/AbcSize
    wait_for(page).to have_content 'Inloggen of registeren'
    fill_in field_name('http://schema.org/email'), with: email
    click_button 'Ga verder'
    wait_for(page).to have_content 'Wachtwoord'
    wait_for(page).to have_field(field_name(NS::ONTOLA[:password].to_s))
    fill_in field_name(NS::ONTOLA[:password].to_s), with: password
    click_button 'Ga verder'
  end

  def fill_in_registration_form(email = 'new@example.com') # rubocop:disable Metrics/AbcSize
    wait_for(page).to have_content('Inloggen of registeren')
    fill_in field_name('http://schema.org/email'), with: email
    click_button 'Ga verder'
    fill_in field_name(NS::ARGU[:pod].to_s, 0, NS::ARGU[:podName].to_s), with: 'new_pod'
    fill_in field_name(NS::ONTOLA[:password].to_s), with: 'password'
    fill_in field_name(NS::ONTOLA[:passwordConfirmation].to_s), with: 'password'
    click_button 'Bevestig'
  end

  def fill_in_select(name = nil, with: nil, selector: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    select = lambda do
      wait_for(page).to have_css("div[aria-labelledby='#{name}-label'] button")
      within "div[aria-labelledby='#{name}-label']" do
        click_button(class: 'SelectInput--selected')
      end
      wait_for(page).to have_css("input[id='#{name}-input'].Input")
      input_field = find("input[id='#{name}-input'].Input").native
      with.split('').each { |key| input_field.send_keys(key) }
      selector ||= /#{with}/
      wait_until_loaded
      wait_for { page }.to have_css('.SelectItem', text: selector)
      find('.SelectItem', text: selector).click
    end
    select.call
  end

  def have_content(string)
    super(/#{Regexp.quote(string)}/i)
  end

  def resource_selector(iri, element: 'div', child: nil, parent: page)
    selector = "#{element}[resource='#{iri}']"
    wait_for { parent }.to have_css selector
    found = parent.find(selector)
    return found if child.nil?

    found.find(child)
  end

  def select_file(file = photo.jpg)
    within("fieldset[property=\"#{NS::DEX[:file]}\"]") do
      attach_file(nil, File.absolute_path("spec/fixtures/#{file}"), make_visible: true)
    end
  end

  def select_radio(label)
    find('label', text: label).click
  end

  def sign_in(user) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    WebMock.allow_net_connect!
    visit "#{Capybara.app_host}/d/health"
    cookies, csrf = authentication_values

    conn = Faraday.new(url: "#{Capybara.app_host}/login") do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end
    response = conn.post do |req|
      req.headers.merge!(
        'Accept': 'application/hex+x-ndjson',
        'Content-Type': 'multipart/form-data',
        'Cookie' => HTTP::Cookie.cookie_value(cookies),
        'X-CSRF-Token' => csrf,
        'Website-IRI' => Capybara.app_host
      )
      req.body = {'<http://purl.org/link-lib/graph>' => login_body(user.email, user.password)}
    end

    expect(response.status).to eq(200)

    cookies.each do |cookie|
      page.driver.browser.manage.add_cookie(name: cookie.name, value: cookie.value)
    end

    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: ALLOWED_HOSTS
    )
  end

  def login_body(actor, password)
    body = <<-FOO
    <http://purl.org/link-lib/targetResource> <http://schema.org/email> "#{actor}" .
    <http://purl.org/link-lib/targetResource> <https://ns.ontola.io/core#password> "#{password}" .
    FOO
    Faraday::UploadIO.new(StringIO.new(body), 'application/n-triples')
  end

  def verify_logged_in
    wait(30).for { page }.to have_css("div[resource=\"#{Capybara.app_host}/c_a\"]", visible: false)
    expect(page).not_to have_content('Log in / registreer')
  end

  def wait_until_loaded
    is_done =
      'return LRS.api.requestMap.size === 0 && '\
      '(LRS.broadcastHandle || LRS.currentBroadcast || LRS.lastPostponed) === undefined;'
    wait_for { page.execute_script(is_done) }.to be_truthy
  end

  private

  def authentication_values
    response = Faraday.get("#{Capybara.app_host}/login")

    cookies = HTTP::CookieJar.new.parse(response.headers['set-cookie'], Capybara.app_host)
    csrf = response.body.match(/<meta name=\"csrf-token\" content=\"(.*)\">/)[1]

    expect(response.status).to eq(200)
    [cookies, csrf]
  end
end

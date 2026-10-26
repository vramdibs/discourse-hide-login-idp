# frozen_string_literal: true

require "rails_helper"

RSpec.describe "discourse-hide-login-idp restrict" do
  fab!(:admin)

  def stub_country(code)
    DiscourseIpInfo.stubs(:get).returns(code.nil? ? {} : { country_code: code })
  end

  def body
    response.parsed_body
  end

  it "restricts a listed country and does not cache the answer" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    stub_country("RU")

    get "/discourse-hide-login-idp/restrict.json"

    expect(response.status).to eq(200)
    expect(body).to eq("restrict" => true)
    expect(response.headers["Cache-Control"]).to eq("private, no-store")
  end

  it "does not restrict a known country outside the list" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    stub_country("FR")

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => false)
  end

  it "treats a missing country as restricted when the switch is on" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    SiteSetting.hide_login_idp_restrict_unknown_country = true
    stub_country(nil)

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => true)
  end

  it "treats a missing country as open when the switch is off" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    SiteSetting.hide_login_idp_restrict_unknown_country = false
    stub_country(nil)

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => false)
  end

  it "treats a lookup error as a missing country" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    SiteSetting.hide_login_idp_restrict_unknown_country = true
    DiscourseIpInfo.stubs(:get).raises(StandardError.new("db"))

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => true)
  end

  it "does not restrict anyone when the country list is empty" do
    SiteSetting.hide_login_idp_country_codes = ""
    stub_country("RU")

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => false)
  end

  it "matches a lowercase country token to the lookup code" do
    SiteSetting.hide_login_idp_country_codes = "ru"
    stub_country("RU")

    get "/discourse-hide-login-idp/restrict.json"

    expect(body).to eq("restrict" => true)
  end

  it "ignores the preview parameter for a guest" do
    SiteSetting.hide_login_idp_country_codes = "RU"
    stub_country("FR")

    get "/discourse-hide-login-idp/restrict.json?login_buttons=restricted"

    expect(body).to eq("restrict" => false)
  end

  it "forces the restricted answer for staff preview even with an empty country list" do
    SiteSetting.hide_login_idp_country_codes = ""
    sign_in(admin)
    stub_country("FR")

    get "/discourse-hide-login-idp/restrict.json?login_buttons=restricted"

    expect(body).to eq("restrict" => true)
  end
end

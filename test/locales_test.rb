# frozen_string_literal: true

require "yaml"

en = YAML.load_file("config/locales/server.en.yml")
ru = YAML.load_file("config/locales/server.ru.yml")
en_keys = en.dig("en", "site_settings").keys.sort
ru_keys = ru.dig("ru", "site_settings").keys.sort
expected = %w[
  hide_login_idp_country_codes
  hide_login_idp_restrict_unknown_country
  hide_login_idp_visible_buttons
]

raise "en keys differ from ru" unless en_keys == ru_keys
raise "site_settings keys #{en_keys.inspect}" unless en_keys == expected
puts "ok"

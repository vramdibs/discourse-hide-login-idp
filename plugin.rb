# frozen_string_literal: true

# name: discourse-hide-login-idp
# about: Hide selected login buttons for visitors from configured country codes
# version: 0.1.0
# authors: rapekas
# url: https://github.com/vramdibs/discourse-hide-login-idp

module ::DiscourseHideLoginIdp
  PLUGIN_NAME = "discourse-hide-login-idp"
end

require_relative "lib/discourse_hide_login_idp/engine"
require_relative "lib/discourse_hide_login_idp/codes"
require_relative "lib/discourse_hide_login_idp/lookup"
require_relative "lib/discourse_hide_login_idp/decision"

after_initialize do
  require_relative "config/hide_login_idp_routes"
end

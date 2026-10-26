# frozen_string_literal: true

Discourse::Application.routes.append do
  get "/discourse-hide-login-idp/restrict" => "discourse_hide_login_idp/restrict#show"
end

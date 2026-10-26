# frozen_string_literal: true

DiscourseHideLoginIdp::Engine.routes.draw do
  get "/discourse-hide-login-idp/restrict" => "restrict#show"
end

Discourse::Application.routes.append do
  mount ::DiscourseHideLoginIdp::Engine, at: "/"
end

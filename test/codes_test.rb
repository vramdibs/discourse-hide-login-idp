# frozen_string_literal: true

require_relative "../lib/discourse_hide_login_idp/codes"

module DiscourseHideLoginIdpCodesCheck
  module_function

  def check(actual, expected, label)
    raise "#{label}: #{actual.inspect} != #{expected.inspect}" unless actual == expected
  end
end

DiscourseHideLoginIdpCodesCheck.check(
  DiscourseHideLoginIdp::Codes.country_codes(" ru | XX1 | FR "),
  %w[RU FR],
  "normalize",
)
DiscourseHideLoginIdpCodesCheck.check(DiscourseHideLoginIdp::Codes.country_codes(""), [], "empty")
DiscourseHideLoginIdpCodesCheck.check(DiscourseHideLoginIdp::Codes.country_codes(nil), [], "nil")
puts "ok"

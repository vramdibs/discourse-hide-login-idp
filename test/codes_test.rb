# frozen_string_literal: true

require_relative "../lib/discourse_hide_login_idp/codes"

def check(actual, expected, label)
  raise "#{label}: #{actual.inspect} != #{expected.inspect}" unless actual == expected
end

check(DiscourseHideLoginIdp::Codes.country_codes(" ru | XX1 | FR "), %w[RU FR], "normalize")
check(DiscourseHideLoginIdp::Codes.country_codes(""), [], "empty")
check(DiscourseHideLoginIdp::Codes.country_codes(nil), [], "nil")
puts "ok"

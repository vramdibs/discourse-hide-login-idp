# frozen_string_literal: true

module DiscourseHideLoginIdp
  module Codes
    module_function

    def country_codes(raw)
      raw.to_s.split("|").filter_map do |token|
        normalized = token.strip.upcase
        normalized if normalized.match?(/\A[A-Z]{2}\z/)
      end.uniq
    end
  end
end

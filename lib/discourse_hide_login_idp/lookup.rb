# frozen_string_literal: true

module DiscourseHideLoginIdp
  class Lookup
    def self.country_code(ip)
      return if ip.blank?

      info = DiscourseIpInfo.get(ip)
      code = info && (info[:country_code] || info["country_code"])
      code.to_s.strip.upcase.presence
    rescue StandardError
      nil
    end
  end
end

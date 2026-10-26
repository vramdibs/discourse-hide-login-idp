# frozen_string_literal: true

module DiscourseHideLoginIdp
  class Decision
    def self.restrict?(ip:, user:, login_buttons:)
      return true if user&.staff? && login_buttons.to_s == "restricted"

      codes = Codes.country_codes(SiteSetting.hide_login_idp_country_codes)
      return false if codes.empty?

      country = Lookup.country_code(ip)
      if country
        codes.include?(country)
      else
        SiteSetting.hide_login_idp_restrict_unknown_country
      end
    end
  end
end

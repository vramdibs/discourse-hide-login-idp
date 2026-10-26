import { apiInitializer } from "discourse/lib/api";
import {
  buildCss,
  normalizeCountryCodes,
  shouldClearOnFailure,
  shouldInjectStyle,
} from "discourse/plugins/discourse-hide-login-idp/lib/hide-login-idp";

const HTML_CLASS = "hide-login-idp-pending";

export default apiInitializer((api) => {
  const siteSettings = api.container.lookup("service:site-settings");
  const user = api.getCurrentUser();
  const preview = new URLSearchParams(window.location.search).get(
    "login_buttons"
  );
  const countryCodesSetting = siteSettings.hide_login_idp_country_codes;
  const isStaffPreview = user?.staff === true && preview === "restricted";

  if (
    !shouldInjectStyle({
      countryCodesSetting,
      isStaff: user?.staff === true,
      preview,
    })
  ) {
    return;
  }

  const style = document.createElement("style");
  style.id = "hide-login-idp";
  style.textContent = buildCss(siteSettings.hide_login_idp_visible_buttons);
  document.head.appendChild(style);
  document.documentElement.classList.add(HTML_CLASS);

  const url = isStaffPreview
    ? "/discourse-hide-login-idp/restrict.json?login_buttons=restricted"
    : "/discourse-hide-login-idp/restrict.json";

  fetch(url, {
    credentials: "same-origin",
    headers: { Accept: "application/json" },
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("restrict failed");
      }
      return response.json();
    })
    .then((body) => {
      if (body && body.restrict === false) {
        document.documentElement.classList.remove(HTML_CLASS);
      }
    })
    .catch(() => {
      if (
        shouldClearOnFailure({
          isStaffPreview,
          hasCountryCodes: normalizeCountryCodes(countryCodesSetting).length > 0,
          restrictUnknown: siteSettings.hide_login_idp_restrict_unknown_country,
        })
      ) {
        document.documentElement.classList.remove(HTML_CLASS);
      }
    });
});

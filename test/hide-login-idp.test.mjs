import assert from "node:assert/strict";
import test from "node:test";
import {
  buildCss,
  normalizeCountryCodes,
  shouldClearOnFailure,
  shouldInjectStyle,
} from "../assets/javascripts/discourse/lib/hide-login-idp.js";

test("country codes keep two-letter tokens only", () => {
  assert.deepEqual(normalizeCountryCodes(" ru | XX1 | FR "), ["ru", "fr"]);
  assert.deepEqual(normalizeCountryCodes(""), []);
  assert.deepEqual(normalizeCountryCodes(null), []);
});

test("style is injected for a configured country or a staff preview", () => {
  assert.equal(
    shouldInjectStyle({
      countryCodesSetting: "",
      isStaff: false,
      preview: "restricted",
    }),
    false
  );
  assert.equal(
    shouldInjectStyle({
      countryCodesSetting: "",
      isStaff: true,
      preview: "restricted",
    }),
    true
  );
  assert.equal(
    shouldInjectStyle({
      countryCodesSetting: "",
      isStaff: true,
      preview: null,
    }),
    false
  );
  assert.equal(
    shouldInjectStyle({
      countryCodesSetting: "RU",
      isStaff: false,
      preview: null,
    }),
    true
  );
});

test("allowlist css hides other social buttons and passkey", () => {
  const css = buildCss("vkid|Yandex");
  assert.match(css, /html\.hide-login-idp-pending \.btn-social:not\(\.vkid\):not\(\.yandex\)/);
  assert.match(css, /html\.hide-login-idp-pending \.passkey-login-button/);
});

test("passkey in the allowlist is not hidden", () => {
  const css = buildCss("passkey");
  assert.match(css, /html\.hide-login-idp-pending \.btn-social \{ display: none !important; \}/);
  assert.equal(css.includes("passkey-login-button"), false);
});

test("empty allowlist hides every social button and passkey", () => {
  const css = buildCss("");
  assert.match(css, /html\.hide-login-idp-pending \.btn-social \{ display: none !important; \}/);
  assert.match(css, /passkey-login-button/);
});

test("a failed fetch clears the hide only for the unknown-country-off case", () => {
  assert.equal(
    shouldClearOnFailure({
      isStaffPreview: false,
      hasCountryCodes: true,
      restrictUnknown: false,
    }),
    true
  );
  assert.equal(
    shouldClearOnFailure({
      isStaffPreview: true,
      hasCountryCodes: true,
      restrictUnknown: false,
    }),
    false
  );
  assert.equal(
    shouldClearOnFailure({
      isStaffPreview: false,
      hasCountryCodes: true,
      restrictUnknown: true,
    }),
    false
  );
  assert.equal(
    shouldClearOnFailure({
      isStaffPreview: false,
      hasCountryCodes: false,
      restrictUnknown: false,
    }),
    false
  );
});

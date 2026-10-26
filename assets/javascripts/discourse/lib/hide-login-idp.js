export function normalizeCountryCodes(value) {
  return String(value || "")
    .split("|")
    .map((token) => token.trim().toLowerCase())
    .filter((token) => /^[a-z]{2}$/.test(token));
}

export function normalizeButtons(value) {
  const seen = new Set();
  const result = [];
  for (const part of String(value || "").split("|")) {
    const token = part.trim().toLowerCase();
    if (!token || seen.has(token)) {
      continue;
    }
    seen.add(token);
    result.push(token);
  }
  return result;
}

export function shouldInjectStyle({ countryCodesSetting, isStaff, preview }) {
  if (normalizeCountryCodes(countryCodesSetting).length > 0) {
    return true;
  }
  return isStaff === true && preview === "restricted";
}

export function buildCss(visibleButtonsSetting) {
  const allowed = normalizeButtons(visibleButtonsSetting);
  const allowedSet = new Set(allowed);
  let social = "html.hide-login-idp-pending .btn-social";
  for (const token of allowed) {
    if (token !== "passkey") {
      social += `:not(.${token})`;
    }
  }
  let css = `${social} { display: none !important; }`;
  if (!allowedSet.has("passkey")) {
    css +=
      " html.hide-login-idp-pending .passkey-login-button { display: none !important; }";
  }
  return css;
}

export function shouldClearOnFailure({
  isStaffPreview,
  hasCountryCodes,
  restrictUnknown,
}) {
  return !isStaffPreview && hasCountryCodes && restrictUnknown === false;
}

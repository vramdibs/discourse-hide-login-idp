# discourse-hide-login-idp

Discourse plugin that hides selected login buttons for visitors from configured countries. OAuth and passkey endpoints stay open. Visitors outside the configured countries, and every visitor while the country list is empty, see the normal login buttons.

## Requirements

- Discourse with the login buttons you want to filter already enabled
- `GeoLite2-City.mmdb` in the app `vendor/data` directory so `DiscourseIpInfo` can resolve a country. This plugin does not download that file

## Install

Clone the plugin in `app.yml` and rebuild:

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/vramdibs/discourse-hide-login-idp.git
```

## Settings

| Setting | Default | Purpose |
|---|---|---|
| `hide_login_idp_country_codes` | empty | ISO alpha-2 codes that share one restricted button set. Empty hides nothing |
| `hide_login_idp_visible_buttons` | empty | Buttons that remain on that screen: `passkey` or a provider class such as `vkid`, `yandex`, `google_oauth2`, `github` |
| `hide_login_idp_restrict_unknown_country` | on | Use the restricted set when the country cannot be read. Ignored while the country list is empty |

Example for a forum that should show VK ID and Yandex to visitors in Russia, and every enabled button to everyone else: `hide_login_idp_country_codes` = `RU`, `hide_login_idp_visible_buttons` = `vkid|yandex`.

Staff can open `/login?login_buttons=restricted` to see the restricted set without being in one of those countries. The same query does nothing for a guest.

## Development checks

```bash
node --test test/hide-login-idp.test.mjs
ruby test/codes_test.rb
ruby test/locales_test.rb
```

The request spec runs in GitHub Actions via the Discourse plugin workflow. It stubs `DiscourseIpInfo` and does not need a GeoIP file.

## License

MIT. See [LICENSE.txt](LICENSE.txt).

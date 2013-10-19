// Firefox preferences

// *******************
// ***** Privacy *****
// *******************
user_pref("privacy.donottrackheader.enabled", true);

// Disallow third party cookies
// 0 = allow all, 1 = only from originating server, 2 = none,
// 3 = third-party only allowed if the site had stored cookies from a
// previous visit (available on Firefox 22.0)
user_pref("network.cookie.cookieBehavior", 3);

// ********************
// ***** Security *****
// ********************

// Don't load HTTP resources when on an HTTPS site
user_pref("security.mixed_content.block_active_content", true);
// Unfortunately, this breaks a lot of sites (e.g. YouTube), so disable it
user_pref("security.mixed_content.block_display_content", false);
// Disable weak encryption
// Remove anything with 128 bit encryption
user_pref("security.ssl3.dhe_dss_aes_128_sha", false);
user_pref("security.ssl3.dhe_dss_camellia_128_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.dhe_rsa_camellia_128_sha", false);
user_pref("security.ssl3.dhe_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_rc4_128_sha", false);
user_pref("security.ssl3.rsa_aes_128_sha", false);
user_pref("security.ssl3.rsa_camellia_128_sha", false);
user_pref("security.ssl3.rsa_rc4_128_md5", false);
user_pref("security.ssl3.rsa_rc4_128_sha", false);
// Remove all ciphers that don't use perfect forward secrecy
user_pref("security.ssl3.rsa_camellia_256_sha", false);
user_pref("security.ssl3.rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_256_sha", false);
// Unortunately, the above restrictions break some sites, so reenable some
// CloudFlare: does support ECDHE-RSA-AES256-CBC-SHA384 for whenever FF updates
user_pref("security.ssl3.ecdhe_ecds_aes_128_sha", true);
//user_pref("security.ssl3.rsa_aes_128_sha", true); // Medium uses CloudFlare
// DuckDuckGo
user_pref("security.ssl3.ecdhe_rsa_aes_128_sha", true);
// Vine: only wants to use RC4 128 bit SHA... well, too bad
// Wikipedia: AES-256-SHA
user_pref("security.ssl3.rsa_aes_256_sha", true);

// ***********************
// ***** Preferences *****
// ***********************
user_pref("browser.tabs.warnOnClose", false);
user_pref("plugins.click_to_play", true);

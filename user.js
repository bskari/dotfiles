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
user_pref("security.mixed_content.block_display_content", true);
// Disable weak encryption
// Anything with 128 bit security is right out
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
// Anything without PFS is out
user_pref("security.ssl3.rsa_seed_sha", false);
user_pref("security.ssl3.rsa_camellia_256_sha", false);
user_pref("security.ssl3.rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_256_sha", false);

// ***********************
// ***** Preferences *****
// ***********************
user_pref("browser.tabs.warnOnClose", false);
user_pref("plugins.click_to_play", true);

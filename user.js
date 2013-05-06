// Firefox preferences

// *******************
// ***** Privacy *****
// *******************
user_pref("privacy.donottrackheader.enabled", true);

// Disallow third party cookies
// 0 = allow all, 1 = only from originating server, 2 = none,
// 3 = third-party only allowed if the site had stored cookies from a
// previous visit (available on Firefox 22.0)
user_pref("network.cookie.cookieBehavior", 2);

// ********************
// ***** Security *****
// ********************
// Don't load HTTP resources when on an HTTPS site
user_pref("security.mixed_content.block_active_content", true);

// ***********************
// ***** Preferences *****
// ***********************
user_pref("browser.tabs.warnOnClose", false);
user_pref("plugins.click_to_play", true);

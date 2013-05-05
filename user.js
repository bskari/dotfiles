// Firefox preferences

var preferences = {
    // *******************
    // ***** Privacy *****
    // *******************

    // Do not track
    "privacy.donottrackheader.enabled": true,

    // Disallow third party cookies
    // 0 = allow all, 1 = only from originating server, 2 = none,
    // 3 = third-party only allowed if the site had stored cookies from a
    // previous visit (available on Firefox 22.0)
    "network.cookie.cookieBehavior": 2,

    // ********************
    // ***** Security *****
    // ********************

    // Don't load HTTP resources when on an HTTPS site
    "security.mixed_content.block_active_content": true,

    // ***********************
    // ***** Preferences *****
    // ***********************

    "browser.tabs.warnOnClose": false
};

for (var key in preferences) {
    user_pref(key, preferences[key]);
}

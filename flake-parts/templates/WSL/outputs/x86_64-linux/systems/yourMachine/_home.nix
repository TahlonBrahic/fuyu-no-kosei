{
  home-manager.users = {
    # Replace with your given user(s)
    "user1".fuyuNoKosei = {
      compositor = {
        enable = false;
      };
    };
    "user2".fuyuNoKosei = {
      browser.chrome.enable = true;
    };
  };
}

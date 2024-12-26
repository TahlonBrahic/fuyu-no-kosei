{
  home-manager.users = {
    # Replace with your given user(s)
    "user1".fuyuNoKosei = {
      compositor = {
        enable = true;
        hyprland.enable = true;
      };
    };
    "user2".fuyuNoKosei = {
      browser.chrome.enable = true;
    };
  };
}

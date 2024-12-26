{lib, ...}: {
  fuyuNoKosei = {
    virtualization.wsl.enable = true;
    tools.enable = true;
  };

  environment.etc."resolv.conf".source = lib.mkForce /etc/resolv.conf;
}

{ config, pkgs, ... }:

{
  networking = {
    hostName = "l470"; # Define your hostname.
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    # L470 Config
    interfaces.enp2s0f0.useDHCP = false;
    interfaces.wlp3s0.useDHCP = false;
    # # Enables wireless support via wpa_supplicant.
    # wireless.enable = true;
    # interfaces.enp0s31f6.useDHCP = true;
    # interfaces.wlp5s0.useDHCP = true;
    wireless.enable = false;
    networkmanager.enable = true;
    wireless.networks = {
      "Nokia 8110 4G" = {
        psk = "lol";
      };
      "TP-Link_EFF4" = {
        psk = "lol";
      };
    };
    extraHosts = ''
    127.0.0.1 tagesschau.de
    127.0.0.1 www.tagesschau.de
    127.0.0.1 reddit.com
    127.0.0.1 www.reddit.com
    127.0.0.1 news.ycombinator.com
    127.0.0.1 www.news.ycombinator.com
    127.0.0.1 youtube.com
    127.0.0.1 www.youtube.com
    '';
  };
}

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tobi";
  home.homeDirectory = "/home/tobi";

  programs.git = {
    enable = true;
    userName = "Floki89";
    userEmail = "weller14@freenet,de";
  };

  home.packages = with pkgs; [
    mtools
    glib
    glibc
    nmap
    youtube-dl
    krita
    gnome.gnome-system-monitor
    cargo
    rustc
    mattermost-desktop
    remmina
  ];

  xsession.enable = true;
  xsession.windowManager.command = "…";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

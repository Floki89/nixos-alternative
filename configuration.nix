# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, ...}:
{
  # We need no bootloader, because the Chromebook can't use that anyway.
  boot.loader.grub.enable = false;

  fileSystems = {
    # Mounts whatever device has the NIXOS_ROOT label on it as /
    # (but it's only really there to make systemd happy, so it wont try to remount stuff).
    "/".label = "NIXOS_ROOT";
  };

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  console.KeyMap = "de";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone
  time.timeZone = "Europe/Berlin";

  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    vim
    wget
    docker-compose
    htop
    feh
  ];

  # Backlight control
  programs.light.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";

  services.xserver.windowManager.i3.enable = true;
  services.xserver.autorun = true;

  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with with passwd
  users.extraUsers.tobi = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
    group = "users";
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/tobi";
    uid = 1000;
  };
  system.stateVersion = "20.11";
}

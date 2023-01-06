# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Configures LUKS encryption
  boot.initrd.luks.devices = {
    root = {
      name = "root";
      device = "/dev/disk/by-uuid/2d961d77-8132-4dcf-a4f3-cc3bee428f73";
      preLVM = true;
      allowDiscards = true;
    };
  };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Configure keymap in X11
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.windowManager.ratpoison.enable = true;

  services.xserver.layout = "de";
  services.xserver.xkbVariant = "neo";
  services.xserver.xkbOptions = "ctrl:swap_lalt_lctl_lwin";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.tobi = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/Tobi";
    hashedPassword = "tobi";
    extraGroups = [ "wheel" "docker" "audio" "video" ];
  };

  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  ];

  environment.systemPackages = with pkgs;
#    chess = pkgs.python3.pkgs.buildPythonPackage rec {
#      pname = "chess";
#      version = "1.4.0";
#      src = python38.pkgs.fetchPypi {
#        inherit pname version;
#        sha256 = "082i54r1fzrsap99pbrrvxmwv9jvzdw24cbc3ii8qsx24ngrf32r";
#      };
#
#      doCheck = false;
#    };
#    python3withPackages = pkgs.python3.withPackages(ps: with ps; [
#      pandas numpy matplotlib scikitlearn notebook chess opencv4 z3
#    ]);
#  in
  [
    direnv nix-direnv
    wget
    git
    thunderbird
    latest.rustChannels.stable.rust
    rust-analyzer
    docker-compose
    python3withPackages
    htop
    pkg-config protobuf protobufc
    feh
    # stm32flash
    # stm32cubemx
    # openocd
    # stlink
    arduino
    youtube-dl
    tarsnap
    audacity
    gnuplot
    stockfish
    gnugo gogui
  ];

#  fonts.fonts = with pkgs; [
#   fira-code
#   fira-code-symbols
#  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #   enableSSHSupport = true;
  #};

  # Backlight control
  programs.light.enable = true;

  location = {
    latitude = 50.87;
    longitude = 8.02;
  };
  services.redshift.enable = true;

  programs.fish.enable = true;

  virtualisation.docker.enable = true;

  networking.useDHCP = false;

  networking.networkmanager.enable = true;
}

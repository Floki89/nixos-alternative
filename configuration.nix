# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Configures LUKS encryption
  boot.initrd.luks.devices = {
    root = {
      name = "root";
      device = "/dev/disk/by-uuid/b3d89ad3-7a89-420c-bce8-da46ee72e0b0";
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
  users.users.leon = {
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
  let
    chess = pkgs.python3.pkgs.buildPythonPackage rec {
      pname = "chess";
      version = "1.4.0";
      src = python38.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "082i54r1fzrsap99pbrrvxmwv9jvzdw24cbc3ii8qsx24ngrf32r";
      };

      doCheck = false;
    };
    python3withPackages = pkgs.python3.withPackages(ps: with ps; [
      pandas numpy matplotlib scikitlearn notebook chess opencv4 z3
    ]);
  in
  [
    direnv nix-direnv
    wget
    vim emacs
    ispell
    git
    mpv cmus spotify
    alacritty
    mkpasswd
    rdiff-backup
    qutebrowser chromium firefox
    pass
    dmenu
    arandr xclip
    tdesktop
    thunderbird
    trash-cli
    acpi
    usbutils # for lsusb
    gimp inkscape
    imagemagick graphviz
    ghc stack hlint
    latest.rustChannels.stable.rust
    rust-analyzer
    cloc
    mpd mpc_cli
    docker-compose
    python3withPackages
    nodejs
    clang
    htop
    pkg-config protobuf protobufc
    feh
    texlive.combined.scheme-full biber
    killall
    # calibre
    unzip
    mupdf
    gnumake
    ncurses portmidi
    # stm32flash
    # stm32cubemx
    # openocd
    # stlink
    wmname
    # arduino
    youtube-dl
    # zoom-us
    element-desktop
    tarsnap
    audacity
    gnuplot
    stockfish
    libnotify
    dunst
    ccls
    android-udev-rules
  #  steam-run-native
    gnugo gogui
    asymptote
    coq
  ];

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  #   enableSSHSupport = true;
  };

  # Backlight control
  programs.light.enable = true;

  location = {
    latitude = 50.87;
    longitude = 8.02;
  };
  services.redshift.enable = true;

  programs.fish.enable = true;

  virtualisation.docker.enable = true;

  systemd.user.services."dunst" = {
    enable = true;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Configure keymap in X11
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.windowManager.ratpoison.enable = true;

  services.xserver.layout = "de";
  services.xserver.xkbVariant = "neo";
  services.xserver.xkbOptions = "ctrl:swap_lalt_lctl_lwin";

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
    home = "/home/tobi";
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
    mpd mpc_cli
    docker-compose
    python3withPackages
    nodejs
    clang
    htop
    feh
    unzip
    mupdf
    gnumake
    ncurses portmidi
    wmname
    # arduino
    youtube-dl
    element-desktop
    tarsnap
    audacity
    gnuplot
    stockfish
    libnotify
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

  };

  system.stateVersion = "20.09"; # Did you read the comment?
}

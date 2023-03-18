{ config, pkgs, ... }: {

  #Bootloader Uefi
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = false;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d6768c27-5a23-471f-965d-abbaf09d8494";
      fsType = "ext4";
    };

  imports = [
    ./hardware-configuration.nix
  ];

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "en_US.UTF-8";
    keyMap = "de";
  };
  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    vim
    nixpkgs-fmt
    wget
    docker-compose
    htop
    feh
    google-chrome
    firefox
    nmap
    unixtools.ifconfig
    vscode
    git
    bmap-tools
    rustup
    clang
    docker
    python3
    wireshark-qt
    cargo
    fprintd
    discord
    steam
  ];

  #exclude gnome default pks
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    gedit
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  networking.networkmanager.enable = true;
  programs.light.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.autorun = true;
  services.xserver.enable = true;
  services.xserver.layout = "de";

  #Fingerprint
  services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  #Printer
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Define a user account.
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

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  boot.loader.grub.enable = false;

  fileSystems = {
    # Mounts whatever device has the NIXOS_ROOT label on it as /
    # (but it's only really there to make systemd happy, so it wont try to remount stuff).
    "/".label = "NIXOS_ROOT";
  };

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = false;
  console = {
    font = "en_US.UTF-8";
    keyMap = "de";
  };

  # Set your time zone
  time.timeZone = "Europe/Berlin";

  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    vim
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
    docker
    python3
    wireshark-qt
    cargo
  ];

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

  # Backlight control
  programs.light.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.autorun = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

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

{ config, pkgs, ... }: {
  boot.loader.grub.enable = false;

  #fileSystems = {
  # Mounts whatever device has the NIXOS_ROOT label on it as /
  # (but it's only really there to make systemd happy, so it wont try to remount stuff).
  # "/".label = "NIXOS_ROOT";
  # };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d6768c27-5a23-471f-965d-abbaf09d8494";
      fsType = "ext4";
    };

  imports = [
    # Include the results of the hardware scan.
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

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.autorun = true;
  services.xserver.enable = true;
  services.xserver.layout = "de";

  services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

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

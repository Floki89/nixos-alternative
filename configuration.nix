# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
#nix-channel --update
#nix-shell '<home-manager>' -A install

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <nixos-hardware/lenovo/thinkpad/p14s/amd/gen2>
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.firewall.interfaces.eth0.allowedTCPPorts = [ 22 25 465 587 ];
  networking.firewall.interfaces.eth0.allowedUDPPorts = [ 5553 ];
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 993 ];

  networking.hostName = "tobi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  #Printer
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tobi = {
    isNormalUser = true;
    description = "tobi";
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [ firefox ];
  };


programs.steam.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-12.2.3" ];
  #List packages installed in system profile. To search, run:
  #$ nix search wget
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
    python3
    wireshark-qt
    cargo
    fprintd
    discord
    steam
    etcher
    home-manager
    vlc
    remmina
    openvpn
    libreoffice-still
    minecraft
    obsidian
    wireguard-tools
    mmctl
    teamviewer
  ];

  virtualisation.docker.enable = true;

  #exclude gnome default pks
  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
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

  #Fingerprint
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
  services.teamviewer.enable = true;
  
  #Enable the OpenSSH daemon.
  #services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.11"; 

}

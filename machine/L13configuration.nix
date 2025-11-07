{ config, pkgs, ... }:
{


  imports = [
    ./hardware-configuration.nix
  ];

      nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
  networking.hostName = "tobi";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  ###################################
  #   Boot & Kernel für Ryzen optimiert
  ###################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ###################################
  # Kernel & Microcode
  ###################################
  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelPackages = pkgs.linuxPackages_latest; # neuester Kernel für bessere Ryzen-Unterstützung

  ###################################
  #   Grafik & Sound
  ###################################
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];

  ###################################
  # Eingabegeräte (Touchpad, TrackPoint, Maus)
  ###################################
  libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };

  desktopManager.plasma6.enable = true;
  displayManager.sddm.enable = true;
};

  #hardware.opengl.enable = true;
  #hardware.opengl.driSupport = true;
  #hardware.opengl.driSupport32Bit = true; # für Steam/Wine etc.

  #sound.enable = true;
  hardware.pulseaudio.enable = false; # PulseAudio wird von PipeWire ersetzt
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ###################################
  #   Laptop & Energieverwaltung
  ###################################
  powerManagement.enable = true;
  services.tlp.enable = true;
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false; # Konflikt mit TLP vermeiden

  ###################################
  #   Bluetooth, Firmware, ThinkPad Features
  ###################################
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.fwupd.enable = true;

  ###################################
  #   Drucker & Scanner
  ###################################
  services.printing.enable = true;
  hardware.sane.enable = true;

  ###################################
  #   Benutzer & Programme
  ###################################
  programs.fish.enable = true;
  users.users.tobi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    pkgs.kdePackages.kate
    google-chrome
    vlc
    libreoffice
    htop
    vim
    nixpkgs-fmt
    wget
    docker-compose
    feh
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
    discord
    steam
    etcher
    vlc
    openvpn
    minecraft
    wireguard-tools
    mmctl
    teamviewer
    ];
  };

  environment.systemPackages = with pkgs; [
    wget curl nano vim
    fish
  ];

  ###################################
  #   Sicherheit & Updates
  ###################################
  security.sudo.enable = true;
  security.polkit.enable = true;
  services.upower.enable = true;

  ###################################
  #   Optional: Energiespar-Extras für Ryzen
  ###################################
  boot.kernelParams = [
    "amd_pstate=active"   # moderne Ryzen-Governor
    "nvme.noacpi=1"       # stabiler bei Suspend/Resume
  ];

  ###################################
  #   Flatpak / AppImage / etc. (optional)
  ###################################
  services.flatpak.enable = true;
}

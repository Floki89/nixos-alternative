{ lib, config, pkgs, ... }: {
  # AMD GPU stuff
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option         "TearFree" "true"
    '';
  };

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
    driversi686Linux.amdvlk
  ];
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work.
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=none"
    # blacklist acpi_cpufreq to use amd p states
    "initcall_blacklist=acpi_cpufreq_init"
  ];

  boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

  };

  networking.networkmanager.enableFccUnlock = true;
  # AT+CGDCONT=1,"IPV4V6","internet.v6.telekom"
  systemd.services.ModemManager.enable = true;
  # dbus-send --system --dest=org.freedesktop.ModemManager1 --print-reply /org/freedesktop/ModemManager1 org.freedesktop.DBus.Introspectable.Introspect

  systemd.services.startModemManager = {
    enable = true;
    path = [ pkgs.dbus ];
    script = ''
      dbus-send --system --dest=org.freedesktop.ModemManager1 --print-reply /org/freedesktop/ModemManager1 org.freedesktop.DBus.Introspectable.Introspect
    '';
    wantedBy = [ "multi-user.target" ];
  };


  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "conservative";

  boot = {
    kernelModules = [ "acpi_call" "amd-pstate" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}

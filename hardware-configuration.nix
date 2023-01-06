
{ lib, pkgs, ... }:

{

  # For suspending to RAM, set Config -> Power -> Sleep State to "Linux" in EFI.

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work.

  # Wifi support
  hardware.firmware = [ pkgs.rtw89-firmware ];

  # For mainline support of rtw89 wireless networking

}

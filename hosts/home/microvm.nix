{ inputs, self, id, ... }:

{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  networking.firewall.allowedTCPPorts = [ 2223 ];

  # Source directory for box's home share. The VM gets it as /home/${id.user}.
  systemd.tmpfiles.rules = [
    "d /home/${id.user}/virtual/box 0755 ${id.user} users -"
  ];

  microvm.vms.box = {
    autostart = true;
    flake = self;
    restartIfChanged = true;
  };
}

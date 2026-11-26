{ inputs, self, ... }:

{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  networking.firewall.allowedTCPPorts = [ 2223 ];

  microvm.vms.box = {
    autostart = true;
    flake = self;
    restartIfChanged = true;
  };
}

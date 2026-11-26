{ id, config, lib, pkgs, ... }:

let
  kernelAtLeast = lib.versionAtLeast config.boot.kernelPackages.kernel.version;

in
{
  microvm = {
    hypervisor = "qemu";
    qemu.extraArgs = [
      "-device"
      "virtio-balloon-pci,free-page-reporting=on"
    ];
    vcpu = 4;
    mem = 6144;

    storeDiskType = "erofs";

    # Stock builder copies the whole closure because a symlink in it dangles in
    # the sandbox. See ./store-disk.nix.
    storeDisk = lib.mkForce (import ./store-disk.nix { inherit config lib pkgs; });

    # This image is rebuilt from scratch on every switch. lz4hc (the upstream
    # default) compresses at about 40 MB/s per core; lz4 is roughly ten times
    # faster and makes the image about 10% bigger. Same flags otherwise.
    storeDiskErofsFlags =
      [ "-zlz4" ]
      ++ lib.optional (kernelAtLeast "5.16") "-Eztailpacking"
      ++ lib.optional (kernelAtLeast "6.1") "-Efragments";

    shares = [
      {
        proto = "virtiofs";
        tag = "nix-tree";
        source = id.repoPath;
        mountPoint = id.repoPath;
      }
      {
        proto = "virtiofs";
        tag = "dotfiles";
        source = "/home/${id.user}/dotfiles";
        mountPoint = "/home/${id.user}/dotfiles";
      }
      {
        proto = "virtiofs";
        tag = "git";
        source = "/home/${id.user}/git";
        mountPoint = "/home/${id.user}/git";
      }
    ];

    volumes = [
      {
        image = "/var/lib/microvms/box/box-store-overlay.img";
        mountPoint = "/nix/.rw-store";
        size = 40960;
        fsType = "ext4";
        autoCreate = true;
      }
      {
        image = "/var/lib/microvms/box/box-nix-var.img";
        mountPoint = "/nix/var";
        size = 4096;
        fsType = "ext4";
        autoCreate = true;
      }
      {
        image = "/var/lib/microvms/box/box-tmp.img";
        mountPoint = "/tmp";
        size = 8192;
        fsType = "ext4";
        autoCreate = true;
      }
    ];

    writableStoreOverlay = "/nix/.rw-store";

    interfaces = [
      {
        type = "user";
        id = "usernet";
        mac = "02:00:00:00:00:01";
      }
    ];

    forwardPorts = [
      {
        from = "host";
        host.port = 2223;
        guest.port = 22;
      }
    ];
  };
}

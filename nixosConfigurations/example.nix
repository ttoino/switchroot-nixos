inputs:
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    inputs.self.nixosModules.switchroot-nixos
    (
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        nixpkgs = {
          # buildPlatform = system;
          # buildPlatform = "x86_64-linux"; # TODO: for now only cross compilation
          # hostPlatform = "aarch64-linux";
          system = "aarch64-linux";
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "nvidia-kernel-modules"
              "nvidia-settings"
              "nvidia-x11"
            ];
        };

        environment.systemPackages = with pkgs; [
          tmux
          btop
          nix-top
          nix-weather
          nvidiaPackages-l4t.tools
          gdb
          lshw
          alsa-utils
          ffmpeg-full
          difftastic
          file
        ];

        users.users.root.initialPassword = "nixos";
        users.users.nixos = {
          initialPassword = "nixos";
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "video"
            "audio"
          ];
        };
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };
        networking.networkmanager.enable = true;
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Use systemd stage-1 to avoid extra-utils glibc mixing issues.
        boot.initrd.systemd.enable = lib.mkForce true;

        fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/SWR-NIXOS";
            fsType = "ext4";
          };
        };
      }
    )
  ];
}

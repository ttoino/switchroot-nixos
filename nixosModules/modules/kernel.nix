{ pkgs, lib, ... }:
{
  boot.kernelPackages =
    if pkgs.stdenv.hostPlatform.isAarch64 && pkgs.stdenv.buildPlatform.isAarch64 then
      pkgs.linuxPackages_4_9-l4t
    else
      pkgs.linuxPackages_4_9-l4t.cross-compiled;
}

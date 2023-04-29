{ lib, pkgs, config, ...}: 
with lib;
let
  cfg = config.modules.gaming.lutris;
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {
  options.modules.gaming.lutris = {
    enable = mkEnableOption "lutris";
    unstable = mkEnableOption "lutris unstable";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (if cfg.unstable then unstable.lutris else lutris)
      (if cfg.unstable then unstable.wineWowPackages.full else wineWowPackages.full)
    ];
  };
}

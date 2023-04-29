{config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.gaming.steam;
in {
  options.modules.gaming.steam.enable = mkEnableOption "steam";
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

}

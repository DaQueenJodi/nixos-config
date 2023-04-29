{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.modules.desktop.xorg;
in {
  options.modules.desktop.xorg = {
    enable = mkEnableOption "xorg";
    repeatDelay = mkOption {
      type = types.nullOr types.int;
      default = 300;
    };
    repeatInterval = mkOption {
      type = types.nullOr types.int;
      default = 30;
    };
    capsBad = mkEnableOption "make caps lock act as ctrl";
    videoDrivers = mkOption {
      type = types.listOf types.str;
      default = ["amdgpu"];
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = (if cfg.capsBad then "ctrl:nocaps" else "");
      autoRepeatInterval = cfg.repeatInterval;
      autoRepeatDelay = cfg.repeatDelay;
      videoDrivers = cfg.videoDrivers;
      displayManager.lightdm.enable = true;
    };
  };
}

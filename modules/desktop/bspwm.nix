{ lib, pkgs, config, services, ...}:
with lib;
let
  cfg = config.modules.desktop.bspwm;
in {
  options.modules.desktop.bspwm.enable = mkEnableOption "bspwm";

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    services.xserver.windowManager.bspwm.enable = true;
    environment.systemPackages = with pkgs; [
      xclip
      maim
      xdotool # for the screenshot shortcut
    ];
  };
}

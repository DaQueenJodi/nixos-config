{ 
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.scripts.menu;
in {
  options.modules.scripts.menu = {
    enable = mkEnableOption "menu";
    package = mkOption {
      default = pkgs.dmenu;
      type = types.package;
    };
    args = mkOption {
      default = "-i";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "menu" ''
        ${cfg.package}/bin/rofi ${cfg.args}
      '')
    ];
  };
}

{lib, pkgs, config, ...}:
with lib;
let
  cfg = config.modules.gaming;
in {
  options.modules.gaming.enable = mkEnableOption "gaming";

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
    ];
  };
}

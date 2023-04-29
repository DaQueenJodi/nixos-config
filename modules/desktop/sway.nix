{
	lib,
	pkgs,
	config,
	...
}:

with lib;
let
  cfg = config.modules.desktop.sway;
  # See https://nixos.wiki/wiki/Sway
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
    dbus-update-activation-environment  --systemd WAYLAND DISPLAY XDG_CURRENT_DESKTOP=sway
    systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in {
	options.modules.desktop.sway.enable = mkEnableOption "sway";

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			grim
			slurp
			wl-clipboard
      bemenu
      dbus-sway-environment
      gnome3.adwaita-icon-theme
		];
		services.dbus.enable = true;
		xdg.portal = {
			enable = true;
			wlr.enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		};
		programs.sway = {
			enable = true;
			wrapperFeatures.gtk = true;
		};
	};
}

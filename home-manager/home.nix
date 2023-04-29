{ lib, config, ... }:
with lib;
let 
	cfg = config.home;
in {
	options.home.enable = mkEnableOption "home-manager stuff";
	config = mkIf cfg.enable {
		home-manager.useUserPackages = true;
		home-manager.useGlobalPkgs = true;
		home-manager.users.jodi = {pkgs, ...}: {
			home.stateVersion = "22.11";
			programs.home-manager.enable = true;
		};
	};
}

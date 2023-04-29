{
	lib,
	pkgs,
	config,
	...
}:
with lib;
let
	cfg = config.home.foot;
in {
	options.home.foot.enable = mkEnableOption "foot";
	options.home.foot.server = mkEnableOption "foot server";
	config = mkIf cfg.enable {
		home-manager.users.jodi = { pkgs, ...}: {
			programs.foot = {
				enable = true;
				server.enable = cfg.server;
				settings = {
					main = {
						term = "xterm-256color";
						dpi-aware = "no";
						font = "monospace:size=12";
					};
				};
			};
		};
	};
}



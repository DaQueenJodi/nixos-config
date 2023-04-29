{ lib, config, pkgs, ...}:
with lib;
let
	cfg = config.home.git;
in {
	options.home.git.enable = mkEnableOption "git";
	config = mkIf cfg.enable {
		home-manager.users.jodi = { pkgs, ...}: {
			programs.git = {
				enable = true;
				userName = "JodiMcJodson";
				userEmail = "isekgood@gmail.com";
			};
		};
	};
}

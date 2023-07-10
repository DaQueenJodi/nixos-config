{ config, pkgs, lib, ...}:
with lib;
let
	cfg = config.home.zsh;
in {
	options.home.zsh.enable = mkEnableOption "zsh";
	
	config = mkIf cfg.enable {
		home-manager.users.jodi = {pkgs, ...}: {
			programs.zsh = {
				enable = true;
				enableCompletion = true;
				defaultKeymap = "emacs";
				history = {
					# save time stamps in history file
					extended = false;
					ignoreDups = true;
					share = true;
					size = 10000;
					save = 10000;
				};
				shellAliases = {
          ls = "ls --color=auto";
					vim = "nvim";
          penis = "xdg-open https://youtube.com &disown &> /dev/null";
				};
				shellGlobalAliases = {
					"..." = "../..";
				};
				initExtra = ''
				PATH="/home/jodi/.local/bin:$PATH"
				setopt PROMPT_SUBST
				function nz {
					nix-shell $@ --run zsh
				}
				function nzp {
					nix-shell -p $@ --run zsh
				}
				function in_shell {
					if ! [ -z "$IN_NIX_SHELL" ]
					then
						echo "[nix] "
					fi
				}
				PS1='$(in_shell)%n@%m %~$ '
				'';
			};
		};
	};
}

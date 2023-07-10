{lib, config, pkgs, ...}:
with lib;
let
  cfg = config.home.vim;
  concatLines = builtins.concatStringsSep "\n";
  tabwidth = "2";
  modeMappings = {
    normal = "nnoremap";
    visual = "vnoremap";
    command = "cnoremap";
  };
  pluginType = mkOptionType {
    name = "plugin";
    check = (x: isDerivation x || (isAttrs x && x ? cfg && x ? pkg ));
  };
in {
  options.home.vim = {
    enable = mkEnableOption "vim";
    extraConfig = mkOption {
      type = types.str;
      default = "";
    };
    plugins = mkOption {
      type = types.listOf pluginType;
      default = [];
    };
    mappings = mkOption {
      type = types.attrs;
      default = {};
    };
    options = mkOption {
      type = types.attrs;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.jodi = {pkgs,...}: {
      programs.vim = {
        enable = true;
        plugins = (map (x: (if (isDerivation x) then x else x.pkg)) cfg.plugins);

        extraConfig = ''
          ${
            concatLines
            (map (x: x.cfg or "") cfg.plugins)
          }
          ${
            "set " +
            (builtins.concatStringsSep " "
            (mapAttrsToList (n: v: 
            (let
              prefix = if (isBool v && v == false) then "no" else "";
              suffix = if (isBool v) then "" else "=${toString v}";
            in
              "${prefix}${n}${suffix}"))
            cfg.options))
          }
          ${
            let
              all = cfg.mappings.all or {};
              visual = cfg.mappings.visual or {};
              normal = cfg.mappings.normal or {};
              command = cfg.mappings.command or {};
              f = (mode: key: act: "${getAttr mode modeMappings} ${key} ${act}");
            in
              concatLines 
              (builtins.concatLists [
                (mapAttrsToList (k: a: f "normal" k a) (recursiveUpdate normal all))
                (mapAttrsToList (k: a: f "visual" k a) (recursiveUpdate visual all))
                (mapAttrsToList (k: a: f "command" k a) (recursiveUpdate command all))
              ])
          }
          ${cfg.extraConfig}
        '';
			};
		};
	};
}

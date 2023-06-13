{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  killall = "${pkgs.killall}/bin/killall";
  curl = "${pkgs.curl}/bin/curl";
  openvpn = "${pkgs.openvpn}/bin/openvpn";
  cfg = config.modules.scripts.menu;
  base_url = "https://configs.ipvanish.com/configs";
  cert = pkgs.fetchurl {
    url = "${base_url}/ca.ipvanish.com.crt";
    sha256 = "j/pZr0+M1pbNo00CVW4xNjQ2RhDXdDkjHLjMLrKFLeM=";
  };
  auth_file = builtins.toFile "auth" ''
  ${(assert cfg.vpn.auth.username != ""; cfg.vpn.auth.username)}
  ${(assert cfg.vpn.auth.password != ""; cfg.vpn.auth.password)}
  '';
in {
  options.modules.scripts.menu.vpn = {
    auth = {
      username = mkOption {
        type = types.str;
        default = "";
      };
      password = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
  config = mkIf cfg.enable {
    security.sudo.extraRules = [
      {
        users = [ "ALL" ];
        commands = [
          {
            command = openvpn;
            options =  [ "NOPASSWD" ];
          }
          {
            command = killall;
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "vpnmenu" ''
      OPTS=$(curl --silent ${base_url}/ | grep -P 'href="ipvanish-.*?a01.ovpn"' | sed -E 's/<a href="(.*)">/\1/')
      NAMES=$(echo "$OPTS" | rev | cut -d '-' -f 3- | rev | cut -d '-' -f 2-)
      NAMES+=$'\nDEFAULT'
      CHOICE=$(echo "$NAMES" | menu)
      if [[ "$CHOICE" == "DEFAULT" ]]
      then
        sudo ${killall} openvpn
        exit 0
      fi
      for OPT in $OPTS
      do
        if [[ "$OPT" == "ipvanish-$CHOICE-"* ]]
        then
          sudo ${killall} openvpn
          ${curl} --silent ${base_url}/$OPT | sudo ${openvpn} --config stdin --ca ${cert} --auth-user-pass ${auth_file}
          exit 0
        fi
      done
      exit 1
      '')
    ];
  };
}


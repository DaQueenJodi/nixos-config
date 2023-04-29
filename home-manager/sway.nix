{ lib, config, pkgs, ...}:
with lib;
let
	cfg = config.home.sway;
in {
	options.home.sway.enable = mkEnableOption "sway";
	options.home.sway.term = mkOption { 
		type = types.str;
		default = "foot";
	};
	options.home.sway.launcher = mkOption {
		type = types.separatedString " ";
		default = "/home/jodi/Scripts/dmenu_launch bemenu -i";
	};
	config = mkIf cfg.enable {
	users.users.jodi.packages = with pkgs; [sway-contrib.grimshot];
		home-manager.users.jodi = {pkgs, ...}: {
			xdg.configFile."sway/config".text = ''
				output HDMI-A-4 resolution 1920x1080 position 0,0
				output DVI-D-1 resolution 1280x1024 position 1920,0

				input type:keyboard {
					repeat_delay 300
					repeat_rate 40
					xkb_options ctrl:nocaps
				}


				set $mod Mod4
				set $left h
				set $down j
				set $up k
				set $right l
				set $term ${cfg.term}
				set $menu ${cfg.launcher}

				bindsym $mod+b exec bluetoothctl connect 28:52:E0:11:81:AF
				bindsym $mod+Shift+b exec bluetoothctl disconnect

				bindsym $mod+Return exec $term
				bindsym $mod+q kill
				bindsym $mod+d exec $menu
				bindsym $mod+Shift+s exec grimshot copy area

				bindsym XF86AudioLowerVolume exec pamixer -d 5
				bindsym XF86AudioRaiseVolume exec pamixer -i 5 --allow-boost
				bindsym XF86AudioMute exec pamixer --toggle-mute

				floating_modifier $mod normal
				bindsym $mod+Shift+c reload
				bindsym $mod+Shift+e exec swaymsg exit

				bindsym $mod+$left focus left
				bindsym $mod+$right focus right
				bindsym $mod+$up focus up
				bindsym $mod+$down focus down
				
				bindsym $mod+Shift+$left move left
				bindsym $mod+Shift+$right move right
				bindsym $mod+Shift+$up move up
        bindsym $mod+Shift+$down move down

				bindsym $mod+1 workspace number 1
				bindsym $mod+2 workspace number 2
				bindsym $mod+3 workspace number 3
				bindsym $mod+4 workspace number 4
				bindsym $mod+5 workspace number 5
				bindsym $mod+6 workspace number 6
				bindsym $mod+7 workspace number 7
				bindsym $mod+8 workspace number 8
				bindsym $mod+9 workspace number 9
				bindsym $mod+0 workspace number 10

				bindsym $mod+Shift+1 move container to workspace number 1
				bindsym $mod+Shift+2 move container to workspace number 2
				bindsym $mod+Shift+3 move container to workspace number 3
				bindsym $mod+Shift+4 move container to workspace number 4
				bindsym $mod+Shift+5 move container to workspace number 5
				bindsym $mod+Shift+6 move container to workspace number 6
				bindsym $mod+Shift+7 move container to workspace number 7
				bindsym $mod+Shift+8 move container to workspace number 8
				bindsym $mod+Shift+9 move container to workspace number 9
				bindsym $mod+Shift+0 move container to workspace number 10

				bindsym $mod+s splitv
				bindsym $mod+Ctrl+s splith
				
				bindsym $mod+f fullscreen
				mode "resize" {
					bindsym $left resize shrink width 10px
					bindsym $down resize grow height 10px
					bindsym $up resize shrink height 10px
					bindsym $right grow shrink width 10px

					bindsym Return mode "default"
					bindsym Escape mode "default"
				}
				bindsym $mod+r mode "resize"
        default_border pixel 1
        # see https://nixos.wiki/wiki/Sway
        exec dbus-sway-environment
			'';
		};
	};
}

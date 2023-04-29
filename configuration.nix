# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports =
    [ 
      ./modules
      ./home-manager
      ./hardware-configuration.nix
      <home-manager/nixos> 
    ];


    nix.settings = {
      experimental-features = [ 
        "nix-command" 
        "flakes"
      ];
    };

    nix.nixPath = [
      "nixos-config=/hdd/Documents/nixos/configuration.nix"
    ];

    nixpkgs.config = {
      allowUnfree = true;
    };



# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = false;
boot.loader.efi.efiSysMountPoint = "/boot/efi";

networking.hostName = "jodi-pc"; # Define your hostname.
networking.wireless.iwd.enable = true;

networking.dhcpcd.enable = true;

# Set your time zone.
time.timeZone = "America/Chicago";

# Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_US.UTF-8";
  LC_IDENTIFICATION = "en_US.UTF-8";
  LC_MEASUREMENT = "en_US.UTF-8";
  LC_MONETARY = "en_US.UTF-8";
  LC_NAME = "en_US.UTF-8";
  LC_NUMERIC = "en_US.UTF-8";
  LC_PAPER = "en_US.UTF-8";
  LC_TELEPHONE = "en_US.UTF-8";

};

# Configure keymap in X11
services.xserver = {
  layout = "us";
  xkbVariant = "";
  xkbOptions = "ctrl:nocaps";
  autoRepeatInterval = 30;
  autoRepeatDelay = 300;
};

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.jodi = {
  shell = pkgs.zsh;
  isNormalUser = true;
  description = "jodi";
  extraGroups = [ "video" "audio" "netdev" "plugdev" "wheel" ];
  packages = with pkgs; [
    (writeShellScriptBin "gtk-launch" ''
    ${pkgs.gtk3}/bin/gtk-launch $@
    '')
    openvpn
    firefox
    pavucontrol
    pamixer
    clang
    pfetch
    qbittorrent
    neovim
    alacritty
    weechat
    i2p
    bottles
    rofi
    github-cli

    prismlauncher
  ];
};

home = {
  enable = true;
  #foot = {
  #  enable = true;
  #  server = true;
  #};
  git.enable = true;
  zsh.enable = true;
  sway.enable = true;
};

# List packages installed in system profile. To search, run:
environment.systemPackages = with pkgs; [
  killall
  wget
  curl
  git
  python3
  vulkan-loader
  vulkan-tools
  file
];

# FONTS
fonts.fonts = with pkgs; [

];

# Services
services = {
  openssh.enable = true;
  jellyfin = {
    enable = true;
    openFirewall = true;
  };
  minecraft-server = {
    package = pkgs.papermc;
    enable = true;
    openFirewall = true;
    eula = true;
  };
};

# desktop stuffs
modules.desktop.bspwm.enable = true;
# fix linux's broken driver for my card
boot.extraModulePackages = with config.boot.kernelPackages;
[
  (rtl88x2bu.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "RinCat";
      repo = "RTL88x2BU-Linux-Driver";
      rev = "a2ac3b2";
      hash = "sha256-9f7H3e2MFW97VRpROfvNmCJdiuEzXjKcGd3ufqliqBI=";
    };
  }))
];
boot.kernelModules = [ "r88x2bu" ];

# security bad
boot.kernelParams = [ "mitigations=off" ];


# set shell
programs.zsh = {
  enable = true;
  enableCompletion = true;
};


# AUDIO
# enable bluetooth
hardware.bluetooth.enable = true;
# enable pipewire and some other stuff the wiki recommends
# https://nixos.wiki/wiki/PipeWire
sound.enable = false;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa = {
    enable = true;
    support32Bit = true;
  };
  pulse.enable = true;
};
# Gaming
modules.gaming = {
  enable = true;
  lutris = {
    enable = false;
    unstable = true;
  };
  steam.enable = true;
};
services.xserver.videoDrivers = [ "amdgpu" ];
services.xserver.deviceSection = ''
  Option "TearFree" "true"
'';

environment.variables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
  WINIT_X11_SCALE_FACTOR = "1.0";
};


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "22.11"; # Did you read the comment?

}

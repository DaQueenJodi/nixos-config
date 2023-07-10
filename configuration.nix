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

    nixpkgs.config = {
      allowUnfree = true;
    };



# Bootloader.
boot.loader.systemd-boot = {
  enable = true;
  configurationLimit = 4;
};
boot.loader.efi.canTouchEfiVariables = false;
boot.loader.efi.efiSysMountPoint = "/boot/efi";


# makes boot times slightly faster
boot.initrd.systemd.enable = true;

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
    chromium
		obs-studio
		gimp
    neovim
    pavucontrol
    pamixer
    clang
    pfetch
    qbittorrent
    alacritty
    weechat
    i2p
    rofi
    github-cli

    renderdoc
    gimp
    gzdoom
    aseprite
    calibre
    tuxpaint
    prismlauncher
    gnome.aisleriot
    (space-cadet-pinball.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "k4zmu2a";
        repo = "SpaceCadetPinball";
        rev = "e466bba";
        sha256 = "73f88GfRSFVDO2xiTGZDUjRK5QaI5aUrHsd2CozzFUs=";
      };
      patches = [];
    }))
  ];
};

home = {
  enable = true;
  /*
  foot = {
    enable = true;
    server = true;
  };
  */
  vim = {
    enable = false;
    plugins = with pkgs.vimPlugins; [
      { pkg = rainbow; cfg = "let g:rainbow_active = 1"; }
      { pkg = gruvbox; cfg = ''
        set background=dark
        let g:gruvbox_italics = 0
        let g:gruvbox_italicize_strings = 0
        colorscheme gruvbox
      '';}
      # vim-nix
      { pkg = zig-vim; cfg = "let g:zig_fmt_autosave = 0"; }
      { pkg = vim-polyglot; cfg = "let g:polyglot_disabled = ['sensible']"; }
  ];
    mappings = {
      normal = {
        "<C-u" = "<C-u>zz";
        "<C-d" = "<C-d>zz";
        "gb" = ":bnext<CR>";
        "gB" = ":bprevious<CR>";
        "gn" = ":next<CR>";
        "gN" = ":previous<CR>";
        "<C-x>" = ":shell<CR>";
      };
      command = {
        "<C-p>" = "<Up>";
        "<C-n>" = "<Down>";
        "<C-b>" = "<Left>";
        "<C-f>" = "<Right>";
      };
      all = {
        "<C-c>" = "<Esc>";
      };
    };
    options = {
      shell = "zsh"; # because nix-shell makes it change to bash
      compatible = false;
      showcmd = true;
      wrap = false;
      shiftwidth = 2;
      tabstop = 2;
      backup = false;
      undofile = false;
      undodir = "$HOME/.vim/undo";
      ignorecase = true;
      incsearch = true;
      lazyredraw = true;
      ruler = true;
      relativenumber = true;
      errorbells = false;
      visualbell = false;
      history = 500;
      magic = true;
    };
    extraConfig = ''
      syntax on
      filetype plugin indent on
      cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : %%
    '';
  };
  git.enable = true;
  zsh.enable = true;
  sway.enable = true;
};

modules.scripts.menu = {
  enable = true;
  package = pkgs.rofi;
  args = "-monitor -1 -dmenu -i";
  vpn = {
    auth = {
      username = "gene.dymarskiy@gmail.com";
      password = "Gagarin2332";
    };
  };
};

# List packages installed in system profile. To search, run:
environment.systemPackages = with pkgs; [
  (stdenv.mkDerivation rec {
    name = "vulkan-manpages";
    src = fetchurl {
    url = "https://github.com/haxpor/Vulkan-Docs/releases/download/v1.2.140/v1.2.140-manpages.zip";
    sha256 = "0XiBGili8Sm0K0MA1jB1Wb52lnJTfecsOyfGy7jd+Os=";
    };
    unpackPhase = ''
    ${pkgs.unzip}/bin/unzip $src
    '';
    installPhase = ''
    mkdir -p $out/share/man/man3
    cp *.3 $out/share/man/man3/
    '';
    outputs = [ "out" ];
    })
    killall
    wget
    curl
    git
    python3
    vulkan-loader
    vulkan-tools
    file

  man-pages
  man-pages-posix
];
documentation = {
  enable = true;
  doc.enable = true;
  dev.enable = true;
  man.enable = true;
};
environment.extraOutputsToInstall = [
  "doc"
  "devdoc"
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
    enable = false;
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
    enable = true;
    unstable = false;
  };
  steam.enable = true;
};
services.xserver.videoDrivers = [ "amdgpu" ];
services.xserver.deviceSection = ''
  Option "TearFree" "true"
'';

environment.variables = {
  EDITOR = "vi";
  VISUAL = "vi";
  WINIT_X11_SCALE_FACTOR = "1.0";
};


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "23.05"; # Did you read the comment?

}

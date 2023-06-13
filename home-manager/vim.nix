{lib, config, pkgs, ...}:
with lib;
let
	cfg = config.home.vim;
  tabwidth = "2";
in {
  options.home.vim.enable = mkEnableOption "vim";
	config = mkIf cfg.enable {
		home-manager.users.jodi = {pkgs,...}: {
			programs.vim = {
				enable = true;
				plugins = with pkgs.vimPlugins; [
					zig-vim
          vim-nix
          gruvbox
        ];
        
        extraConfig = ''
          set nocompatible
          filetype plugin indent on
          syntax on

          set background=dark
          colorscheme gruvbox
          let g:gruvbox_italics = 0
          let g:gruvbox_italicize_strings = 0

          set shiftwidth=${tabwidth}
          set tabstop=${tabwidth}

          set nobackup undofile
          set undodir=$HOME/.vim/undo
          ${
            # map C-c to work as Esc in all modes
            builtins.concatStringsSep "\n"
            (map (x: x + "noremap <C-c> <Esc>") ["i" "c" "v" "n"])
          }

          set ignorecase hlsearch incsearch lazyredraw
          set encoding=utf-8
          set wrap linebreak
          set ruler relativenumber
          set noerrorbells novisualbell
          set confirm
          set history=500
          set magic
          
          nmap <C-u> <C-u>zz
          nmap <C-d> <C-d>zz


          cnoremap <C-p> <Up>
          cnoremap <C-n> <Down>
          cnoremap <C-b> <Left>
          cnoremap <C-f> <Right>

          noremap <silent> [b :bprevious<CR>
          noremap <silent> ]b :bnext<CR>
          noremap <silent> [B :bfirst<CR>
          noremap <silent> ]B :blast<CR>

          cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
        '';
			};
		};
	};
}

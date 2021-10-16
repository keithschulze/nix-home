{ config, pkgs, lib, ... }:

let
  vim-zettel = pkgs.vimUtils.buildVimPlugin {
    name = "vim-zettel";
    src = pkgs.fetchFromGitHub {
      owner = "michal-h21";
      repo = "vim-zettel";
      rev = "5f046caa2044d2ecd08ff0ce7aa0e73d70a77e50";
      sha256 = "0jrwirz6dhhd4mhrw5vvkdvfhla22hcmxfgxbqdcl272cgpplg5x";
    };
  };

  coc-explorer = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "coc-sh";
    version = "2020-09-15";
    src = pkgs.fetchFromGitHub {
      owner = "josa42";
      repo = "coc-sh";
      rev = "179138ed7ceb04b02a40b7541ec8fd6843721712";
      sha256 = "163kj7m2388rr17hr21wgrl7bhfx0l9ilwg1g5vh38isdjkk0vh0";
    };
    meta.homepage = "https://github.com/josa42/coc-sh/";
  };
in {
  enable = true;
  # extraConfig = builtins.readFile ../../config/neovim/extraConfig.vim;
  extraConfig = builtins.concatStringsSep "\n" [
    (lib.strings.fileContents ../../config/neovim/base.vim)
    ''
      lua << EOF
      ${lib.strings.fileContents ../../config/neovim/lsp.lua}
      EOF
    ''
  ];

  extraPython3Packages = (ps: with ps; [jedi]);

  plugins = with pkgs.vimPlugins; [
    vim-nix
    vim-repeat
    vim-fugitive
    vim-surround
    vim-commentary

    vim-peekaboo
    vim-slash
    fzf-vim
    gv-vim

    vim-gitgutter
    vim-easymotion
    vim-polyglot
    vim-rooter
    vim-tmux-navigator
    vim-bufkill

    nerdtree
    luasnip
    nvim-cmp
    cmp-nvim-lsp
    cmp_luasnip

    # Style
    nord-vim
    tokyonight-nvim
    # airline
    lightline-vim
    vim-airline-themes

    # LSP
    nvim-lspconfig

    vimwiki
    vim-zettel
  ];
}

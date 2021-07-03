{ config, lib, pkgs, ... }:
let
  vscodeBase = (import ../../program/vscode/default.nix) { inherit config; inherit pkgs; };
  vscodeBaseExts = vscodeBase.extensions;
in {

  home.packages = with pkgs; [
    # utils
    jq
    htop
    fzf
    ripgrep
    fd

    # dev
    shellcheck
    tmux
    tmuxinator
    graphviz

    # languages
    nodejs
    adoptopenjdk-hotspot-bin-16

    # tools
    poetry
    cookiecutter
    awscli2
    saml2aws
    geckodriver
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      # keychain = {
      #   host = "*";
      #   extraOptions = {
      #     UseKeychain    = "yes";
      #     AddKeysToAgent = "yes";
      #     IgnoreUnknown  = "UseKeychain";
      #   };
      #   identityFile = "~/.ssh/id_ed25519";
      # };
      "github.com" = {
        hostname = "github.com";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519";
      };
      "thoughtworks.github.com" = {
        hostname = "github.com";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519_thoughtworks";
      };
      "stash.reecenet.org" = {
        hostname = "stash.reecenet.org";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
        identityFile = "~/.ssh/id_ed25519_reece";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Keith Schulze";
    userEmail = "keith.schulze@reece.com.au";
    aliases = {
      co = "checkout";
      up = "!git pull --rebase --prune $@";
      cob = "checkout -b";
      cm = "!git add -a && git commit -m";
      save = "!git add -a && git commit -m 'savepoint'";
      wip = "!git add -u && git commit -m 'wip'";
      undo = "reset head~1 --mixed";
      amend = "commit -a --amend";
      wipe = "!git add -a && git commit -qm 'wipe savepoint' && git reset head~1 --hard";
    };
    extraConfig = {
      color.ui = true;
      push.default = "simple";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.tool = "vimdiff";
      difftool.prompt = false;
      core.commitGraph = true;
      gc.writeCommitGraph = true;
      init.defaultBranch = "main";
    };
    signing = {
      key = "653A35CECE7873BE";
      signByDefault = true;
    };
  };

  programs.neovim = (import ../../program/neovim/default.nix) { inherit config; inherit pkgs; };

  programs.tmux = (import ../../program/tmux/default.nix) { inherit pkgs; };

  programs.starship = import ../../program/starship/default.nix;

  programs.vscode = lib.attrsets.overrideExisting vscodeBase {
    extensions = vscodeBaseExts ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.65.7";
        sha256 = "10ynl4pzlxy2k8f2zk3nfkp81br12a2aa6hzpd3zfnpwg6zc91mf";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.65.7";
        sha256 = "1q5x6ds2wlg3q98ybvic00j19l33pablx7wczywa7fc26f8h9xzj";
      }
    ];

  };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../program/zsh/default.nix) {

    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
              . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
          else
              export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      PATH=$HOME/.bin:$PATH
    '';
    sessionVariables = {
      AWS_DEFAULT_PROFILE = "beach";
    };
    oh-my-zsh = {
      plugins = [
        "git"
        "docker-compose"
        "ripgrep"
        "tmux"
        "zsh_reload"
        "kubectl"
      ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = import ../../program/alacritty/default-settings.nix;
  };

  # home.file.".config/tmuxinator/hotdoc.yml".source = ./config/tmux/hotdoc.yml;
}

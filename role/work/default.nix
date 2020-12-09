{ config, lib, pkgs, attrsets, ... }:

{

  programs.neovim = import ../../program/neovim/default.nix;

  programs.tmux = import ../../program/tmux/default.nix;

  programs.starship = import ../../program/starship/default.nix;

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../program/zsh/default.nix) {
    shellAliases = {
      #K8s
      k8s-data-staging = "kubectl config set-context internal.\${CSR_USER} --namespace hotdoc-data-staging";
      k8s-data = "kubectl config set-context internal.\${CSR_USER} --namespace hotdoc-data";
      k8s-airflow = "kubectl config set-context internal.\${CSR_USER} --namespace airflow";
      k8s-airflow-staging = "kubectl config set-context internal.\${CSR_USER} --namespace airflow-staging";
    };

    sessionVariables = rec {
      CSR_USER = "keithschulze";
    };

    initExtra = ''
      # bindkey "^R" history-incremental-search-backward

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
    oh-my-zsh = {
      plugins = [
        "git"
        "docker-compose"
        "gcloud"
        "ripgrep"
        "terraform"
        "tmux"
        "zsh_reload"
        "kubectl"
      ];
    };
  };

  programs.vscode = import ../../program/vscode/default.nix;

  home.file.".config/tmuxinator/hotdoc.yml".source = ./config/tmux/hotdoc.yml;
}

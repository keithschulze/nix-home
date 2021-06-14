{ config, pkgs, lib, ... }:

{
  programs.neovim = (import ../../program/neovim/default.nix) { inherit config; inherit pkgs; };

  programs.tmux = (import ../../program/tmux/default.nix) { inherit pkgs; };

  programs.starship = import ../../program/starship/default.nix;

  programs.vscode = (import ../../program/vscode/default.nix) { inherit config; inherit pkgs; };

  programs.zsh = lib.attrsets.recursiveUpdate (import ../../program/zsh/default.nix) {
    initExtra = ''
      if [ -n "''\${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
              . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
          else
              export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      PATH=/Users/keithschulze/.cargo/bin:/opt/homebrew/bin:$PATH
      PATH=/opt/homebrew/opt/openjdk/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
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

  programs.alacritty = {
    enable = true;
    settings = import ../../program/alacritty/default-settings.nix;
  };
}

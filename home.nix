{ config, pkgs, ... }:

{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "keithshulze";
  home.homeDirectory = "/Users/keithshulze";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  news.display = "silent";

  nixpkgs.config.allowUnfree = true;

  programs.ssh.enable = true;

  home.packages = with pkgs; [
    # utils
    jq
    htop
    fzf
    ripgrep
    fd

    # dev
    awscli2
    shellcheck
    tmux
    tmuxinator
    graphviz

    # languages
    gcc
    jdk11
    nodejs

    # language tools
    rustup
    poetry
    cookiecutter


    # work
    sops
    google-cloud-sdk
    terraform
    aws-vault
    erlang
    elixir
    cfssl
    kubectl
  ];

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Keith Schulze";
    userEmail = "keith.schulze@hey.com";
    aliases = {
      co = "checkout";
      up = "!git pull --rebase --prune $@";
      cob = "checkout -b";
      cm = "!git add -A && git commit -m";
      save = "!git add -A && git commit -m 'SAVEPOINT'";
      wip = "!git add -u && git commit -m 'WIP'";
      undo = "reset HEAD~1 --mixed";
      amend = "commit -a --amend";
      wipe = "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";
    };
    extraConfig = {
      github.user = "keithschulze";
      color.ui = true;
      push.default = "simple";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.tool = "vimdiff";
      difftool.prompt = false;
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
    signing = {
      key = "777B8C453E6ADE9C";
      signByDefault = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = {
      size = 50000;
      save = 50000;
    };
    shellAliases = {
      vw = "nvim -c VimwikiIndex";

      mux="tmuxinator";

      #K8s
      k8s-data-staging = "kubectl config set-context internal.\${CSR_USER} --namespace hotdoc-data-staging";
      k8s-data = "kubectl config set-context internal.\${CSR_USER} --namespace hotdoc-data";
      k8s-airflow = "kubectl config set-context internal.\${CSR_USER} --namespace airflow";
      k8s-airflow-staging = "kubectl config set-context internal.\${CSR_USER} --namespace airflow-staging";

      # Random passwords
      gen-pwd = "openssl rand -base64 32";
    };
    sessionVariables = rec {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden";
      CSR_USER = "keithschulze";
      CC = "clang";
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

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./config/extraConfig.vim;

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

      # Style
      nord-vim
      airline

      # Languages
      coc-nvim
      coc-python
      coc-yaml
      coc-json
      coc-rust-analyzer
      coc-explorer

      vimwiki
      vim-zettel
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.symbol = "  ";
      battery = {
        full_symbol = "";
        charging_symbol = "";
        discharging_symbol = "";
      };
      conda.symbol = " ";
      dart.symbol = " ";
      docker.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      gcloud.symbol = "  ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      haskell.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      memory_usage.symbol = " ";
      nim.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = " ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      swift.symbol = "ﯣ ";
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 102400;
    terminal = "screen-256color";
    tmuxinator.enable = true;
    extraConfig = ''
      # Don't use a login shell
      set-option -g default-command $SHELL

      # Change bind key to ctrl-a
      unbind-key c-b
      set-option -g prefix c-a

      # Renumber windows when a window is closed
      set-option -g renumber-windows on

      # Repeat time limit (ms)
      set-option -g repeat-time 500

      # True color support
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Key binding in the status line (bind-key :)
      set-option -g status-keys vi

      # Mouse
      set-option -g mouse on

      # -------------------------------------------------------------------
      # Window options
      # -------------------------------------------------------------------
      # Copy-mode
      set-window-option -g mode-keys vi

      # -------------------------------------------------------------------
      # Key bindings
      # -------------------------------------------------------------------
      # prefix c
      bind-key c new-window -c "#{pane_current_path}"

      # prefix ctrl-a
      bind-key c-a last-window

      # prefix a
      bind-key a send-prefix

      # prefix |
      bind-key | split-window -h -c "#{pane_current_path}"

      # prefix -
      bind-key - split-window -c "#{pane_current_path}"

      # Moving windows
      bind-key -r > swap-window -t :+
      bind-key -r < swap-window -t :-

      # Back and forth
      bind-key bspace previous-window
      bind-key space next-window
      bind-key / next-layout # Overridden

      # Pane-movement
      bind-key h select-pane -L
      bind-key l select-pane -R
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key tab select-pane -t :.+
      bind-key btab select-pane -t :.-

      # Synchronize panes
      bind-key * set-window-option synchronize-pane

      # Reload ~/.tmux.conf
      bind-key R source-file ~/.tmux.conf \; display-message "Reloaded!"

      # Capture pane and open in Vim
      bind-key C-c run 'tmux capture-pane -S -102400 -p > /tmp/tmux-capture.txt'\;\
                   new-window "view /tmp/tmux-capture.txt"
      bind-key M-c run "screencapture -l$(osascript -e 'tell app \"iTerm\" to id of window 1') -x -o -P /tmp/$(date +%Y%m%d-%H%M%S).png"

      # -------------------------------------------------------------------
      # fzf integration
      # -------------------------------------------------------------------
      # Tmux completion
      bind-key -n 'M-t' run "tmux split-window -p 40 'tmux send-keys -t #{pane_id} \"$(tmuxwords.rb --all --scroll 1000 --min 5 | fzf --multi | paste -sd\\  -)\"'"

      # fzf-locate (all)
      bind-key -n 'M-`' run "tmux split-window -p 40 'tmux send-keys -t #{pane_id} \"$(locate / | fzf -m | paste -sd\\  -)\"'"

      # select-pane (@george-b)
      bind-key 0 run "tmux split-window -l 12 'bash -ci ftpane'"
    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      (pkgs.callPackage ./lib/tmux {}).nord
    ];
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.bbenoist.Nix
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.redhat.vscode-yaml
      vscode-extensions.vscodevim.vim
      vscode-extensions.matklad.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "github-vscode-theme";
        publisher = "Github";
        version = "1.1.3";
        sha256 = "a09df93744c400807a8418d110e8b12c480c8c129f439a0996a90159938d618d";
      }
      {
        name = "plantuml";
        publisher = "jebbs";
        version = "2.13.13";
        sha256 = "998726aa18f2b475da17208977f9590b37aed6c4b27419732f21691fcac48214";
      }
      {
        name = "python";
        publisher = "ms-python";
        version = "2020.8.106424";
        sha256 = "80b7f5704ff8f8094d700bf74cc375d6cc1a753a4ce36a62fb4e46c4d00436bc";
      }
      {
        name = "vscode-pylance";
        publisher = "ms-python";
        version = "2020.11.2";
        sha256 = "0n2dm21vgzir3hx1m3pmx7jq4zy3hdxfsandd2wv5da4fs9b5g50";
      }
      {
        name = "vsliveshare-pack";
        publisher = "MS-vsliveshare";
        version = "0.4.0";
        sha256 = "c5375f3aa772a40696a66b5820cd07ee0c02cb58d7365e7e1daaef556ff70226";
      }
      {
        name = "elixir-ls";
        publisher = "JakeBecker";
        version = "0.6.1";
        sha256 = "1rrbn4vyx033jcbgqhfpqjqahr3qljawljzal8j73kk0z12kqglf";
      }
    ];
    userSettings = {
      "workbench.colorTheme" = "GitHub Dark";
      "vim.easymotion" = true;
      "vim.insertModeKeyBindings" = [
          {
              "before" = [
                  "f"
                  "d"
              ];
              "after" = [
                  "<Esc>"
              ];
          }
          {
              "before" = [
                  "j"
                  "k"
              ];
              "after" = [
                  "<Esc>"
              ];
          }
      ];
      "vim.normalModeKeyBindingsNonRecursive" = [
          {
              "before" = [
                  "<C-l>"
              ];
              "after" = [
                  "<C-w>"
                  "l"
              ];
          }
          {
              "before" = [
                  "<C-h>"
              ];
              "after" = [
                  "<C-w>"
                  "h"
              ];
          }
          {
              "before" = [
                  "<C-j>"
              ];
              "after" = [
                  "<C-w>"
                  "j"
              ];
          }
          {
              "before" = [
                  "<C-k>"
              ];
              "after" = [
                  "<C-w>"
                  "k"
              ];
          }
          {
              "before" = [
                  "leader"
                  "w"
                  "v"
              ];
              "after" = [
                  "<C-w>"
                  "v"
              ];
          }
          {
              "before" = [
                  "leader"
                  "w"
                  "h"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.splitEditorDown";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "p"
                  "t"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.toggleSidebarVisibility";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "b"
                  "c"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.closeActiveEditor";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "f"
                  "f"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.quickOpen";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "b"
                  "b"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.quickOpen";
                      "args" = [
                          "edt "
                      ];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "t"
                  "t"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "workbench.action.terminal.toggleTerminal";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "l"
                  "d"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "editor.action.peekDefinition";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "l"
                  "r"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "editor.action.goToReferences";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "l"
                  "q"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "editor.action.quickFix";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "l"
                  "n"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "editor.action.rename";
                      "args" = [];
                  }
              ];
          }
          {
              "before" = [
                  "leader"
                  "l"
                  "h"
              ];
              "after" = [];
              "commands" = [
                  {
                      "command" = "editor.action.showHover";
                      "args" = [];
                  }
              ];
          }
      ];
      "vim.visualModeKeyBindingsNonRecursive" = [
          {
              "before" = [
                  ">"
              ];
              "commands" = [
                  "editor.action.indentLines"
              ];
          }
          {
              "before" = [
                  "<"
              ];
              "commands" = [
                  "editor.action.outdentLines"
              ];
          }
      ];
      "vim.leader" = "<space>";
      "editor.fontFamily" = "Iosevka, Menlo, 'Courier New', monospace";
      "editor.fontSize" = 15;
      "editor.minimap.enabled" = false;
      "editor.rulers" = [
          80
      ];
      "vim.enableNeovim" = true;
      "vim.textwidth" = 80;
      "vim.neovimPath" = "/Users/keithshulze/.nix-profile/bin/nvim";
      "vim.gdefault" = true;
      "vim.sneak" = true;
      "vim.useSystemClipboard" = true;
      "vim.overrideCopy" = true;
      "editor.renderWhitespace" = "none";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "files.trimTrailingWhitespace" = true;
      "window.restoreWindows" = "none";
      "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/*.pyc" = true;
          "**/.classpath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.factorypath" = true;
      };
      "editor.renderControlCharacters" = false;
      "terminal.integrated.fontSize" = 15;
      "terminal.integrated.shellArgs.osx" = [];
      "markdown.preview.fontSize" = 15;
      "vim.easymotionMarkerFontSize" = "15";
      "editor.formatOnSave" = true;
      "breadcrumbs.enabled" = true;
      "editor.suggestSelection" = "first";
      "python.languageServer" = "Pylance";
      "workbench.activityBar.visible" = true;
      "workbench.editor.showTabs" = false;
      "files.insertFinalNewline" = true;
    };
  };

  home.file.".config/tmuxinator/hotdoc.yml".source = ./config/tmux/hotdoc.yml;
}

{ fetchFromGitHub
, pkgs
}:

with pkgs.tmuxPlugins; {
  nord = mkDerivation {
    pluginName = "nord";
    version = "unstable-2019-07-04";
    src = fetchFromGitHub {
      owner = "arcticicestudio";
      repo = "nord-tmux";
      rev = "v0.3.0";
      sha256 = "14xhh49izvjw4ycwq5gx4if7a0bcnvgsf3irywc3qps6jjcf5ymk";
    };
  };
}

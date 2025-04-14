{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    initExtra = ''
      eval "$(direnv hook zsh)"
    '';
    shellAliases = {
      dots = "cd ~/nixconf";
      proj = "cd ~/Projects";
    };
  };
  home.packages = lib.mkAfter (
    with pkgs;
    [
      fzf
    ]
  );
}

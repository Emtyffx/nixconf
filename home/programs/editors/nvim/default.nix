{ pkgs, lib, ... }:
let
  reqs = with pkgs; [
    git
    gcc
    gnumake
    unzip
    wget
    curl
    tree-sitter
    ripgrep
    fd
    fzf
    cargo
    lazygit
    nodePackages.npm
    python3
    luajitPackages.luarocks
    lua51Packages.lua
    libxml2
    imagemagick
    lua-language-server
    stylua
    nixd

    nodejs
    deno
    bun
    yarn
    pnpm
    nixfmt-rfc-style
  ];
  linuxOnlyReqs =
    if pkgs.stdenv.isDarwin then
      with pkgs; [ ]
    else
      with pkgs;
      [
        wl-clipboard
        xsel
        ninja
        meson
        pkg-config
      ];

  nvim-pkg =
    with pkgs;
    wrapNeovimUnstable neovim-unwrapped {
      withRuby = true;
      withNodeJs = true;
      withPython3 = true;
      wrapRc = false;
      wrapperArgs = ''--suffix PATH : "${lib.makeBinPath (reqs ++ linuxOnlyReqs)}"'';
    };
in
{
  home.packages = with pkgs; lib.mkAfter [ nvim-pkg ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  xdg = {
    configFile.nvim.source = ./.;
    desktopEntries."nvim" = lib.mkIf pkgs.stdenv.isLinux {
      name = "Neovim";
      comment = "Best text editor";
      icon = "nvim";
      exec = "${nvim-pkg}/bin/nvim %F";
      terminal = true;
      categories = [ "TerminalEmulator" ];
      mimeType = [ "text/plain" ];
    };
  };
}

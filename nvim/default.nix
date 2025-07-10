{ pkgs, ... }:
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
    nodePackages.prettier
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
    vtsls
    pyright
    vscode-langservers-extracted

    # debuggers
    delve
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

with pkgs;
wrapNeovimUnstable neovim-unwrapped {
  withRuby = true;
  withNodeJs = true;
  withPython3 = true;
  wrapRc = false;
  wrapperArgs = ''--suffix PATH : "${lib.makeBinPath (reqs ++ linuxOnlyReqs)}"'';
}

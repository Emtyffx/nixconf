{ inputs, config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.homeModules.nvim =
    { lib, pkgs, ... }:
    let
      codelldb = pkgs.callPackage ../../pkgs/codelldb/package.nix { };
      reqs = with pkgs; [
        arduino-language-server
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
        lazygit
        nodePackages.npm
        nodePackages.prettier
        python3
        luajitPackages.luarocks
        rustc
        cargo

        libxml2
        imagemagick
        lua-language-server
        rust-analyzer
        ruff
        nodePackages_latest.nodejs
        nixd
        deno
        bun
        yarn
        pnpm
        nixfmt-rfc-style
        vtsls
        pyright
        gopls
        vscode-langservers-extracted
        vue-language-server
        neocmakelsp
        svelte-language-server
        delve
        vscode-extensions.vadimcn.vscode-lldb.adapter

        emmet-ls
        tailwindcss-language-server
        platformio
        codelldb

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
      home.packages = [ nvim-pkg ];

      home.sessionVariables = {
        EDITOR = meta.defaults.editor;
        VISUAL = meta.defaults.editor;

      };

      xdg = {
        configFile."nvim".source = ../../non-nix/nvim;
        configFile."nvim".recursive = true;
        configFile."nvim".target = "nvim";

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
    };
}

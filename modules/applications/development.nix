{ inputs, config, ... }:
{
  flake.homeModules.development =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        go
        gnumake
        cmake
        bear

        # clang
        clang-tools
        adw-gtk3
        llvmPackages.lldb
        llvmPackages.libcxx
        llvmPackages.libcxxClang
        gdb

        sl

        lazygit
        rustc
        cargo

        yarn
        pnpm
        bun
        nodePackages_latest.nodejs

      ];
    };
}

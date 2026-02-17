{ lib, vscode-extensions }:

# Ensure the path matches your nixpkgs version (usually vadimcn.vscode-lldb)
vscode-extensions.vadimcn.vscode-lldb.overrideAttrs (oldAttrs: {
  pname = "codelldb";

  # Use + to join strings
  postFixup = (oldAttrs.postFixup or "") + ''
    mkdir -p $out/bin

    ln -s "$out/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb" "$out/bin/codelldb"
  '';
})

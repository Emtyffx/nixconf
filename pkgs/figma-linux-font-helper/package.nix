{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "figma-linux-font-helper";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "Figma-Linux";
    repo = "figma-linux-font-helper";
    rev = "v${version}";
    hash = "sha256-0Akdz5Bc15Ph9B/2nvvYwAAq1hjV6+k7eY9+W2n8ODo=";
  };

  cargoHash = "sha256-rJgeD10oGVfEw0WWfHO2vaoAdOHoVVt60B3TWHZjpoo=";

  meta = {
    description = "Font Helper for Figma for Linux x64 platform";
    homepage = "https://github.com/Figma-Linux/figma-linux-font-helper";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "figma-linux-font-helper";
  };
  postInstall = ''

    mkdir -p $out/lib/systemd/user/

    mv res/figma-fonthelper.service $out/lib/systemd/user/
    sed -i "s|ExecStart=.*fonthelper'|ExecStart=$out/bin/font_helper|" $out/lib/systemd/user/figma-fonthelper.service

    substituteInPlace $out/lib/systemd/user/figma-fonthelper.service \
      --replace-fail "ExecStop=" "# ExecStop=" \
      --replace-fail "multi-user.target" "graphical-session.target"

  '';
}

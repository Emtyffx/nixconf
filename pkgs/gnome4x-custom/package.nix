{
  lib,
  stdenv,
  fetchFromGitHub,
  name,
  accent,
  text,
  sassc,
  glib,
  inkscape,
  bc,
  imagemagick,
  optipng,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-4x-${name}";
  version = "20251121";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "GNOME-4X-themes";
    tag = finalAttrs.version;
    hash = "sha256-RRFxkUVIPlE2KCURkqBhchmBReac6uh7sdpAtTEcYds=";
  };

  nativeBuildInputs = [
    sassc
    glib
    inkscape
    bc
    optipng
    imagemagick
  ];
  buildInputs = [
    gtk3
  ];

  meta = {
    description = "GNOME 4X Themes is a project dedicated to customizing the GNOME desktop environment starting from version 40 ";
    homepage = "https://github.com/daniruiz/GNOME-4X-themes/";
    changelog = "https://github.com/daniruiz/GNOME-4X-themes//blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gnome-4x-themes";
    platforms = lib.platforms.linux;
  };

  buildPhase = ''
    patchShebangs .
    ./generate-color-theme.sh "${name}" "${accent}" "${text}"
  '';

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r themes/GNOME-4X-${name}* $out/share/themes
  '';
})

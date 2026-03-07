{
  flat-remix-icon-theme,
  name,
  accent,
  accent-light,
  text,
  gnumake,
  fetchFromGitHub,
}:
flat-remix-icon-theme.overrideAttrs (oldAttrs:
# let
#   tag = "20251119";
# in
{
  # version = tag;
  # src = fetchFromGitHub {
  #   owner = "daniruiz";
  #   repo = "flat-remix";
  #   tag = tag;
  #   hash = "sha256-tQCzxMz/1dCsPSZHJ9bIWCRjPi0sS7VhRxttzzA7Tr4=";
  #
  # };
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    gnumake
  ];
  buildPhase = ''
    patchShebangs .
    # substitude new color scheme
    cd color-folder
    sed -i "/^colors=(/ s/)/ ${name})/" generate-colors.sh
    sed -i "/^color1_new=(/ s/)/ '${accent}')/" generate-colors.sh
    sed -i "/^color2_new=(/ s/)/ '${accent-light}')/" generate-colors.sh
    sed -i "/^color3_new=(/ s/)/ '${text}')/" generate-colors.sh
    ./generate-colors.sh
    cd ..
    make generate_folder_variants
    # make generate_theme_variants 
  '';
})

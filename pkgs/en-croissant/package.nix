{ en-croissant, makeWrapper }:
en-croissant.overrideAttrs (oldAttrs: {
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
  postInstall = (oldAttrs.postInstall or "") + ''
      	wrapProgram $out/bin/en-croissant \
    		--set WEBKIT_DISABLE_COMPOSITING_MODE "1" 
  '';
})

{ inputs,  pkgs, ...}:
{
	imports = [
		inputs.nixvim.homeManagerModules.nixvim
	];
	
	programs.nixvim = {
		enable = true;	
		colorschemes.gruvbox.enable = true;
		plugins = {
			lualine.enable = true;
			bufferline.enable = true;
		};
	};
}

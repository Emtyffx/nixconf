{ config, pkgs, ... }:
let
  helpers = config.lib.nixvim;
in
{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      lazyLoad.enable = true;
      lazyLoad.settings = {
        keys = [
          {
            __unkeyed-1 = "ss";
            mode = [
              "n"
              "x"
              "o"
            ];
            __unkeyed-3 = helpers.mkRaw ''
              function() require("flash").jump()  end
            '';
            desc = "Flash";
          }
          {
            __unkeyed-1 = "sS";
            mode = [
              "n"
              "x"
              "o"
            ];
            __unkeyed-3 = helpers.mkRaw ''function() require("flash").treesitter() end'';
            desc = "Flash Treesitter";
          }
          {
            __unkeyed-1 = "r";
            mode = [ "o" ];
            __unkeyed-3 = helpers.mkRaw ''function() require("flash").remote() end'';
            desc = "Remote Flash";
          }
          {
            __unkeyed-1 = "R";
            mode = [ "o" ];
            __unkeyed-3 = helpers.mkRaw ''function() require("flash").treesitter_search() end'';
            desc = "Treesitter search Flash";
          }
          {
            __unkeyed-1 = "<c-s>";
            mode = [ "c" ];
            __unkeyed-3 = helpers.mkRaw ''function() require("flash").toggle() end'';
            desc = "Toggle Flash Search";
          }

        ];
      };
    };
  };
}

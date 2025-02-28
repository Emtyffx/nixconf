{ config, plugins, ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      nil_ls = {
        enable = true;
      };
      vtsls = {
        enable = true;
        filetypes = [
          "javascript"
          "javascriptreact"
          "javascript.jsx"
          "typescript"
          "typescriptreact"
          "typescript.tsx"
        ];
        settings = {
          complete_function_calls = true;
          vtsls = {
            enableMoveToFileCodeAction = true;
            autoUseWorkspaceTsdk = true;
            experimental = {
              maxInlayHintLength = 30;
              completion = {
                enableServerSideFuzzyMatch = true;
              };
            };
          };

          typescript = {
            updateImportsOnFileMove = {
              enabled = "always";
            };
            suggest = {
              completeFunctionCalls = true;
            };
            inlayHints = {
              enumMemberValues = {
                enabled = true;
              };
              functionLikeReturnTypes = {
                enabled = true;
              };
              parameterNames = {
                enabled = "literals";
              };
              parameterTypes = {
                enabled = true;
              };
              propertyDeclarationNames = {
                enabled = true;
              };
              variableTypes = {
                enabled = true;
              };
            };
          };
        };
      };
    };
  };
}

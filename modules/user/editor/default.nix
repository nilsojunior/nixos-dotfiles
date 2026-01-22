{
    config,
    lib,
    pkgs,
    ...
}:
let
    editor = config.userSettings.editor;
in
    {
        options = {
            userSettings.editor = lib.mkOption {
                type = lib.types.enum [
                    "emacs"
                    "nvim"
                    "vim"
                ];
                default = "vim";
                description = "Default Editor";
            };
        };

        config = lib.mkMerge [
            (lib.mkIf (editor == "vim") {
                programs.vim.enable = true;
            })
            {
                home.sessionVariables = {
                    EDITOR = editor;
                    VISUAL = editor;
                };
            }
        ];
    }

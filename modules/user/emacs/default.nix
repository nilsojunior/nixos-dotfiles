{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userSettings.emacs;
in
{
  options = {
    userSettings.emacs.enable = lib.mkEnableOption "Enables Emacs";
  };

  config = lib.mkIf cfg.enable {
    # stylix.targets.emacs.enable = false;
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages =
        epkgs: with epkgs; [
          evil
          evil-collection
          evil-commentary
          org
          org-modern
          general
          undo-fu
          undo-fu-session

          diredfl
          vertico
          consult
          orderless
          corfu
          cape

          nix-ts-mode
          just-mode
          (treesit-grammars.with-grammars (
            grammars: with grammars; [
              tree-sitter-rust
              tree-sitter-nix
              tree-sitter-lua
              tree-sitter-just
            ]
          ))
        ];
      extraConfig = ''
                    (org-babel-load-file
                        (expand-file-name
                        "config.org"
                        user-emacs-directory))
                '';
    };

    # home.file.".emacs.d/config.org".source = ./config.org;
  };
}

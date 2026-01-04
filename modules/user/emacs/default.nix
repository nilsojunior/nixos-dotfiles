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
        programs.emacs = {
            enable = true;
            package = pkgs.emacs-pgtk;
            extraPackages =
                epkgs: with epkgs; [
                    evil
                    evil-collection
                ];
            extraConfig = ''
                    ;; 1. Set the flag BEFORE loading evil
                (setq evil-want-minibuffer t)

                ;; 2. Load evil
                (require 'evil)
                (evil-mode 1)

                ;; 3. Optional: Better minibuffer keys via evil-collection
                (setq evil-collection-setup-minibuffer t)
                (with-eval-after-load 'evil
                  (require 'evil-collection)
                  (evil-collection-init))
            '';
        };
    };
}

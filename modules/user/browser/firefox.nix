{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:
let
    cfg = config.userSettings.firefox;
    keepass = config.userSettings.keepass.enable;
in
{
    options = {
        userSettings.firefox.enable = lib.mkEnableOption "Enable Firefox";
    };

    config = lib.mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            profiles.nilso = {
                extensions = {
                    packages =
                        with inputs.firefox-addons.packages."x86_64-linux";
                        [
                            ublock-origin
                            vimium-c
                        ]
                        # If keepass is true install the extension
                        ++ lib.optional keepass keepassxc-browser;
                };

                search = {
                    force = true;
                    engines = {
                        rust = {
                            name = "Rust";
                            urls = [ { template = "https://doc.rust-lang.org/std/?search={searchTerms}"; } ];
                            icon = "https://doc.rust-lang.org/favicon.ico";
                            definedAliases = [ "!rust" ];
                        };
                        github = {
                            name = "GitHub";
                            urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
                            icon = "https://github.com/favicon.ico";
                            definedAliases = [ "!gh" ];
                        };
                        youtube = {
                            name = "Youtube";
                            urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
                            icon = "https://youtube.com/favicon.ico";
                            definedAliases = [ "!yt" ];
                        };
                        imdb = {
                            name = "Imdb";
                            urls = [ { template = "http://www.imdb.com/find?ref_=nv_sr_fn&q="; } ];
                            icon = "https://imdb.com/favicon.ico";
                            definedAliases = [ "!imdb" ];
                        };
                        yandex = {
                            name = "Yandex";
                            urls = [ { template = "https://yandex.ru/yandsearch?text={searchTerms}"; } ];
                            icon = "https://yandex.ru/favicon.ico";
                            definedAliases = [ "!yan" ];
                        };
                    };
                };

                settings = {
                    "browser.startup.homepage" = "about:blank";
                    # Custom CSS
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                };
            };
        };
    };
}

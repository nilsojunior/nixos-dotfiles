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
                    # Do i need this?
                    force = true;
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
                    # NOTE: duckduckgo has most of this stuff already bultuin so should probably remove them
                    # but it's kinda good to have it in case I change the search engine in the future.
                    default = "ddg";
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
                    # Automatically restore session
                    "browser.startup.page" = 3;

                    "browser.startup.homepage" = "about:blank";
                    "browser.newtabpage.enabled" = "about:blank";

                    # Custom CSS
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

                    # Remove search engine icon from search bar
                    "browser.urlbar.scotchBonnet.enableOverride" = false;

                    # Bookmarks bar
                    "browser.toolbars.bookmarks.visibility" = "never";

                    # Top left icon
                    "browser.tabs.firefox-view" = false;

                    # TODO: check how to do this
                    # File picker
                    # "widget.use-xdg-desktop-portal.file-picker" = 1;

                    "full-screen-api.ignore-widgets" = true;
                };

                userChrome = /* CSS */ ''
                        * {
                        /* font-family: "Inter" !important; */
                        font-weight: 600;
                        font-size: 12px;
                        }

                        #save-to-pocket-button {
                        display: none;
                        }

                        .tab-close-button.close-icon {
                        display: none;
                        }

                        #fxa-toolbar-menu-button {
                        display: none;
                        }

                        #sidebar-button {
                        display: none;
                        }

                        #reload-button {
                        display: none;
                        }

                        #forward-button {
                        display: none;
                        }

                        #back-button {
                        display: none;
                        }

                        .titlebar-button.titlebar-close {
                        display: none;
                        }

                        #star-button-box {
                        display: none;
                        }

                        #alltabs-button {
                        display: none;
                        }

                        #unified-extensions-button:hover {
                        opacity: 1;
                        }

                        #unified-extensions-button {
                        opacity: 0;
                        }

                        #PanelUI-menu-button:hover {
                        opacity: 1;
                        }

                        #PanelUI-menu-button {
                        opacity: 0;
                        }

                        #stop-button {
                        opacity: 0;
                        }

                        #stop-button:hover {
                        opacity: 1;
                        }

                        #tabs-newtab-button {
                        display: none;
                        }

                        .tabbrowser-tab:not([selected="true"]):not(:hover) .tab-content {
                        opacity: 0.7;
                                             }
                    '';
            };
        };
    };
}

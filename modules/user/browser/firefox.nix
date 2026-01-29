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
    stylix = config.userSettings.stylix.enable;
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
/* font-weight: 600; */
font-weight: bold;
font-size: 12px;
}

#save-to-pocket-button,
#fxa-toolbar-menu-button,
#sidebar-button,
#reload-button,
#forward-button,
#back-button,
#star-button-box,
#alltabs-button,
#tabs-newtab-button,
#urlbar-search-mode-indicator-close,
.titlebar-button.titlebar-close,
.close-icon.findbar-closebutton,
.tab-close-button.close-icon {
    display: none;
}

#unified-extensions-button:hover,
#PanelUI-menu-button:hover,
#stop-button:hover {
    opacity: 1;
}

#unified-extensions-button,
#PanelUI-menu-button,
#stop-button {
    opacity: 0;
}

.tabbrowser-tab:not([selected="true"]):not(:hover) .tab-content {
    opacity: 0.5;
                     }

:root {
	--uc-navbar-transform: calc(0px - var(--tab-min-height) - 3px);
}

#navigator-toolbox > div {
	display: contents;
}

:root:is([customizing], [chromehidden*="toolbar"]) :where(
	#nav-bar,
	#PersonalToolbar,
	#tab-notification-deck,
	.global-notificationbox
                                      ) {
	transform: none !important;
	opacity: 1 !important;
                                      }

#nav-bar:not([customizing]) {
	opacity: 0;
	position: relative;
	z-index: 2;
	pointer-events: none;
}

#titlebar {
	position: relative;
	z-index: 3;
}

#navigator-toolbox,
#sidebar-box,
#sidebar-main,
#sidebar-splitter,
#tabbrowser-tabbox {
	z-index: auto !important;
}

/* Show when toolbox is focused, like when urlbar has received focus */
#navigator-toolbox:focus-within > .browser-toolbar {
	transform: translateY(0);
	opacity: 1;
    pointer-events: auto;
}

:root[sessionrestored] #urlbar[popover] {
	opacity: 0;
	pointer-events: none;
	transform: translateY(var(--uc-navbar-transform));
}

#mainPopupSet:has(> [panelopen]:not(
	#ask-chat-shortcuts,
	#selection-shortcut-action-panel,
	#chat-shortcuts-options-panel,
	#tab-preview-panel
)) ~ toolbox #urlbar[popover],
#urlbar-container > #urlbar[popover]:is([focused], [open]) {
	opacity: 1;
	pointer-events: auto;
	transform: translateY(0);
}

/* This ruleset is separate, because not having :has support breaks other selectors as well */
#mainPopupSet:has(> [panelopen]:not(
	#ask-chat-shortcuts,
	#selection-shortcut-action-panel,
	#chat-shortcuts-options-panel,
	#tab-preview-panel
)) ~ #navigator-toolbox > .browser-toolbar {
	transform: translateY(0);
	opacity: 1;
}

/* Move up the content view */
:root[sessionrestored]:not([chromehidden~="toolbar"]) > body > #browser {
	margin-top: var(--uc-navbar-transform);
}

:root[inFullscreen] > body > #browser {
	margin-top: 0 !important;
}

${lib.optionalString stylix ''
:root {
    --arrowpanel-background: #${config.lib.stylix.colors.base01} !important;
}

menupopup{
    --panel-background: #${config.lib.stylix.colors.base01} !important;
}

#navigator-toolbox {
    background: #${config.lib.stylix.colors.base00} !important;
    color: #${config.lib.stylix.colors.base05} !important;
}

/* Tab Active */
.tab-background:is([selected], [multiselected]) {
	background: #${config.lib.stylix.colors.base00} !important;
}
.tabbrowser-tab:is([selected], [multiselected]) .tab-label {
    color: #${config.lib.stylix.colors.base05} !important;
}

/* Tab: hovered colors */
#tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
	background: #${config.lib.stylix.colors.base00} !important;
	color: #${config.lib.stylix.colors.base05} !important;
}

/* Top Bar */
#nav-bar {
    background: #${config.lib.stylix.colors.base00} !important;
    color: #${config.lib.stylix.colors.base05} !important;
}

.urlbar-background {
    background: #${config.lib.stylix.colors.base01} !important;
}

/* Find Bar */
.browserContainer > findbar {
    background: #${config.lib.stylix.colors.base00} !important;
    color: #${config.lib.stylix.colors.base05} !important;
}
.findbar-textbox {
    background: #${config.lib.stylix.colors.base01} !important;
    color: #${config.lib.stylix.colors.base05} !important;
    border: none !important;
}
.findbar-textbox::placeholder {
    color: transparent !important;
}

/* Bottom left tooltip */
#statuspanel-label {
  background: #${config.lib.stylix.colors.base00} !important;
  color: #${config.lib.stylix.colors.base05} !important;
}

::selection {
    background: #${config.lib.stylix.colors.base0D} !important;
}

/* https://www.reddit.com/r/FirefoxCSS/comments/pq0eyi/how_to_remove_the_blue_border_around_urlbar/ */
:root{ --toolbar-field-focus-border-color: transparent !important; }

/* safari style tab width */
.tabbrowser-tab[fadein] {
	max-width: 100vw !important;
	border: none
}

.tabbrowser-tab {
	/* remove border between tabs */
	padding-inline: 0px !important;
	/* reduce fade effect of tab text */
	--tab-label-mask-size: 1em !important;
	/* fix pinned tab behaviour on overflow */
	overflow-clip-margin: 0px !important;
}

/* disable tab shadow */
#tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
    box-shadow: none !important;
}

/* remove titlebar spacers */
/* top right thingy */
.titlebar-spacer { display: none !important; }
 ''}
                '';
            };
        };
    };
}

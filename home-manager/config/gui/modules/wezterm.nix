{
  config,
  pkgs,
  ...
}: let
  renderFrontend =
    if pkgs.stdenv.isDarwin
    then "WebGpu"
    else "OpenGL";
in {
  config.programs.wezterm = {
    inherit (config.homeManagerConfig.gui) enable;
    extraConfig = ''
      local wezterm = require("wezterm")

      local config = wezterm.config_builder()

      local font = wezterm.font({
        family = "Maple Mono NF CN",
        weight = "Regular",
        harfbuzz_features = { "locl=0", "cv01=1", "cv03=1", "ss03=1" },
      })

      --------------------------------------------------------------------------------
      --                                Color Scheme                                --
      --------------------------------------------------------------------------------
      local function scheme_by_appearance()
        local appearance = "Dark"
        if wezterm.gui then
          appearance = wezterm.gui.get_appearance()
        end

        local scheme
        if appearance:find("Dark") then
          scheme = "nordfox"
        else
          scheme = "dawnfox"
        end
        return scheme, wezterm.color.get_builtin_schemes()[scheme]
      end

      local scheme, colors = scheme_by_appearance()
      config.color_scheme = scheme

      --------------------------------------------------------------------------------
      --                                   Window                                   --
      --------------------------------------------------------------------------------
      config.window_frame = {
        font = font,
        font_size = 11.0,
        active_titlebar_bg = colors.background,
        inactive_titlebar_bg = colors.split,
      }
      config.window_background_opacity = 0.7
      config.macos_window_background_blur = 20

      if colors.tab_bar ~= nil then
        config.colors = {
          tab_bar = colors.tab_bar,
        }
      end

      config.max_fps = 160

      config.window_decorations = "RESIZE"

      -- adaptive window padding
      wezterm.on("window-resized", function(window, pane)
        local window_dims = window:get_dimensions()
        local pane_dims = pane:get_dimensions()

        local padding_left = (window_dims.pixel_width - pane_dims.pixel_width) / 2
        -- local padding_top = (window_dims.pixel_height - pane_dims.pixel_height) / 2

        local overrides = window:get_config_overrides() or {}
        overrides.window_padding = {
          left = padding_left,
          right = 0,
          -- top = padding_top,
          top = 0,
          bottom = 0,
        }

        window:set_config_overrides(overrides)
      end)

      --------------------------------------------------------------------------------
      --                                  Launcher                                  --
      --------------------------------------------------------------------------------

      config.ssh_domains = wezterm.default_ssh_domains()
      config.default_domain = "local"

      --------------------------------------------------------------------------------
      --                                    Font                                    --
      --------------------------------------------------------------------------------
      config.font = font
      config.font_size = 11

      config.custom_block_glyphs = false

      --------------------------------------------------------------------------------
      --                                   Cursor                                   --
      --------------------------------------------------------------------------------
      config.default_cursor_style = "BlinkingBar"

      --------------------------------------------------------------------------------
      --                                    MISC                                    --
      --------------------------------------------------------------------------------
      config.use_ime = true
      config.front_end = "${renderFrontend}"

      return config
    '';
  };
}

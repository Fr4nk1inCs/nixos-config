---@diagnostic disable:undefined-global

local font = wezterm.font({
	family = "Maple Mono NF CN",
	weight = "Regular",
	harfbuzz_features = font_features,
})
config.font = font
config.custom_block_glyphs = false

config.macos_window_background_blur = 20
config.max_fps = 160
config.window_decorations = "RESIZE"
-- adaptive window padding
wezterm.on("window-resized", function(window, pane)
	local window_dims = window:get_dimensions()
	local pane_dims = pane:get_dimensions()

	local padding_left = (window_dims.pixel_width - pane_dims.pixel_width) / 2

	local overrides = window:get_config_overrides() or {}
	overrides.window_padding = {
		left = padding_left,
		right = 0,
		top = 0,
		bottom = 0,
	}

	window:set_config_overrides(overrides)
end)

config.ssh_domains = wezterm.default_ssh_domains()
config.default_domain = "local"

config.default_cursor_style = "BlinkingBar"

config.use_ime = true

return config

-- PaperWM
PaperWM = hs.loadSpoon("PaperWM")

PaperWM.screen_margin = 10
PaperWM.window_gap = 10
PaperWM.window_ratios = { 1 / 3, 1 / 2, 2 / 3 }
PaperWM.center_mouse = false
PaperWM.lift_window = { "alt" }

PaperWM:bindHotkeys({
	focus_left = { "alt", "h" },
	focus_right = { "alt", "l" },
	focus_up = { "alt", "k" },
	focus_down = { "alt", "j" },

	focus_prev = { "alt", "[" },
	focus_next = { "alt", "]" },

	swap_left = { { "alt", "shift" }, "h" },
	swap_right = { { "alt", "shift" }, "l" },
	swap_up = { { "alt", "shift" }, "k" },
	swap_down = { { "alt", "shift" }, "j" },

	center_window = { "alt", "c" },
	full_width = { "alt", "m" },
	cycle_width = { "alt", "r" },
	reverse_cycle_width = { { "alt", "shift" }, "r" },
	cycle_height = { { "ctrl", "alt" }, "r" },
	reverse_cycle_height = { { "ctrl", "alt", "shift" }, "r" },

	increase_width = { "alt", "=" },
	decrease_width = { "alt", "-" },

	slurp_in = { { "alt", "shift" }, "i" },
	barf_out = { { "alt", "shift" }, "o" },

	toggle_floating = { { "alt", "shift" }, "space" },

	switch_space_l = { "alt", "," },
	switch_space_r = { "alt", "." },
	switch_space_1 = { "alt", "1" },
	switch_space_2 = { "alt", "2" },
	switch_space_3 = { "alt", "3" },
	switch_space_4 = { "alt", "4" },
	switch_space_5 = { "alt", "5" },
	switch_space_6 = { "alt", "6" },
	switch_space_7 = { "alt", "7" },
	switch_space_8 = { "alt", "8" },
	switch_space_9 = { "alt", "9" },

	move_window_1 = { { "alt", "shift" }, "1" },
	move_window_2 = { { "alt", "shift" }, "2" },
	move_window_3 = { { "alt", "shift" }, "3" },
	move_window_4 = { { "alt", "shift" }, "4" },
	move_window_5 = { { "alt", "shift" }, "5" },
	move_window_6 = { { "alt", "shift" }, "6" },
	move_window_7 = { { "alt", "shift" }, "7" },
	move_window_8 = { { "alt", "shift" }, "8" },
	move_window_9 = { { "alt", "shift" }, "9" },
})
PaperWM:start()

WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse.margin = 2
WarpMouse:start()

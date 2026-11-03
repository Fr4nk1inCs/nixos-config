---@class KeyMapping
---@field [1] string Key stroke within the group.
---@field [2] string Rex action name.
---@field [3] table<string, any>? Optional action arguments.

---@class GroupSpec
---@field from? string Parent group; omitted for entry from terminal input.
---@field enter string Single key stroke, including modifiers; no mode or sequence prefix.
---@field persistent? boolean Keep the group active after commands; defaults to false.
---@field keys KeyMapping[] Commands available in this group.

---@class ModeEntry
---@field name string
---@field once? boolean Exit after one command when true.

-- Groups are states; from + enter defines an edge into each state.
-- Backspace returns to from; Escape/Ctrl+C exit all groups.
---@type table<string, ModeEntry>
local entries = {}

---@param name string
---@param mappings KeyMapping[]
local function bind_keys(name, mappings)
	for _, mapping in ipairs(mappings) do
		rex.bind(name .. "/" .. mapping[1], mapping[2], mapping[3])
	end
end

---@param name string
---@param parent string
local function bind_back(name, parent)
	local action = "back_from_" .. name
	rex.action({
		name = action,
		title = "Back to " .. parent,
		category = "Keys",
		run = function()
			rex.client.queue("client.mode.exit_all")
			rex.client.queue("client.mode.enter", entries[parent])
		end,
	})
	rex.bind(name .. "/backspace", action)
end

---@param name string
---@param spec GroupSpec
local function group(name, spec)
	rex.mode(name, { exclusive = true })
	local entry = { name = name }
	if not spec.persistent then
		entry.once = true
	end
	entries[name] = entry
	local key = spec.from and (spec.from .. "/" .. spec.enter) or spec.enter
	rex.bind(key, "client.mode.enter", entry)

	bind_keys(name, {
		{ "escape", "client.mode.exit_all" },
		{ "ctrl+c", "client.mode.exit_all" },
	})
	if spec.from then
		bind_back(name, spec.from)
	else
		rex.bind(name .. "/backspace", "client.mode.exit_all")
	end
	bind_keys(name, spec.keys)
end

group("leader", {
	enter = "ctrl+b",
	keys = {
		{ "ctrl+b", "pane.send_key", { key = "ctrl+b" } },
		{ "shift+;", "client.palette.toggle" },
		{ "-", "pane.split", { direction = "down" } },
		{ "shift+\\", "pane.split", { direction = "right" } },
		{ "shift+r", "client.config.reload" },
		{ "h", "pane.focus", { direction = "left" } },
		{ "j", "pane.focus", { direction = "down" } },
		{ "k", "pane.focus", { direction = "up" } },
		{ "l", "pane.focus", { direction = "right" } },
	},
})

group("windows", {
	from = "leader",
	enter = "w",
	keys = {
		{ "d", "pane.close" },
		{ "m", "pane.zoom" },
		{ "=", "pane.balance" },
		{ "h", "pane.focus", { direction = "left" } },
		{ "j", "pane.focus", { direction = "down" } },
		{ "k", "pane.focus", { direction = "up" } },
		{ "l", "pane.focus", { direction = "right" } },
		{ "shift+h", "pane.move", { direction = "left" } },
		{ "shift+j", "pane.move", { direction = "down" } },
		{ "shift+k", "pane.move", { direction = "up" } },
		{ "shift+l", "pane.move", { direction = "right" } },
	},
})

group("resize", {
	from = "windows",
	enter = "r",
	persistent = true,
	keys = {
		{ "=", "pane.balance" },
		{ "enter", "client.mode.exit_all" },
		{ "i", "client.mode.exit_all" },
		{ "q", "client.mode.exit_all" },
		{ "ctrl+;", "client.palette.toggle" },
		{ "h", "pane.resize", { direction = "left", amount = 5 } },
		{ "j", "pane.resize", { direction = "down", amount = 5 } },
		{ "k", "pane.resize", { direction = "up", amount = 5 } },
		{ "l", "pane.resize", { direction = "right", amount = 5 } },
		{ "shift+h", "pane.resize", { direction = "left", amount = 15 } },
		{ "shift+j", "pane.resize", { direction = "down", amount = 15 } },
		{ "shift+k", "pane.resize", { direction = "up", amount = 15 } },
		{ "shift+l", "pane.resize", { direction = "right", amount = 15 } },
	},
})

group("tabs", {
	from = "leader",
	enter = "tab",
	keys = {
		{ "tab", "client.tab.new" },
		{ "[", "client.tab.previous" },
		{ "]", "client.tab.next" },
		{ "f", "client.tab.goto", { index = 1 } },
		{ "l", "client.tab.goto", { index = -1 } },
		{ "d", "client.tab.close" },
	},
})

group("sessions", {
	from = "leader",
	enter = "s",
	keys = {
		{ "s", "session.switch" },
		{ "n", "session.new" },
		{ "r", "session.rename" },
		{ "[", "session.previous" },
		{ "]", "session.next" },
		{ "d", "session.close" },
	},
})

group("machines", {
	from = "leader",
	enter = "m",
	keys = {
		{ "m", "client.host.switch" },
		{ "a", "client.host.add" },
		{ "d", "client.host.remove" },
		{ "p", "client.pair_device" },
	},
})

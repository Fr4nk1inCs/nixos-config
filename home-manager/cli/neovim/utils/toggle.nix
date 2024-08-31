_: {
  programs.nixvim.extraConfigLuaPre = ''
    utils.toggle = {}

    ---@param lhs string
    ---@param name string
    ---@param get fun(): boolean
    ---@param set fun(state: boolean)
    ---@param notify fun(state: boolean)
    utils.toggle.keymap = function(lhs, name, get, set, notify)
      notify = notify or function(state)
        if state then
          utils.notify("Enabled " .. name, vim.log.levels.INFO, { title = name })
        else
          utils.notify("Disabled " .. name, vim.log.levels.WARN, { title = name })
        end
      end

      vim.keymap.set(
        "n",
        lhs,
        function()
          local new_state = not get()
          set(new_state)
          notify(new_state)
        end,
        {
          desc = "Toggle " .. name,
          silent = true
        }
      )

      local function safe_get()
        local ok, value = pcall(get)
        if not ok then
          utils.notify(
            "Error getting state for **" .. name .. "**: " .. value,
            vim.log.levels.ERROR,
            { title = "Error", once = true }
          )
        end
        return value
      end

      require("which-key").add({
        {
          lhs = lhs,
          icon = function()
            return safe_get() and { icon = " ", color = "green" } or { icon = " ", color = "yellow" }
          end,
          desc = function()
            return (safe_get() and "Disable " or "Enable ") .. name
          end
        }
      })
    end
  '';
}

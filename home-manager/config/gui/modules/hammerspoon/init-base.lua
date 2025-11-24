-- Hammerspoon Configuration File

-- Load SpoonInstall for managing spoons
ReloadConfiguration = hs.loadSpoon("ReloadConfiguration")

ReloadConfiguration.watch_paths = { "~/.config/hammerspoon/" }
ReloadConfiguration:start()

-- Add more spoons and configurations as needed

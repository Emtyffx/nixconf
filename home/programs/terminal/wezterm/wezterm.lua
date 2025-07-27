local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.window_decorations = "NONE"
config.enable_wayland = true

config.front_end = "Software"
config.wayland_use_syncobj = false

return config

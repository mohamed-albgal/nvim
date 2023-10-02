-- i created this to easily mimic vscode's ability to use 2 windows side by side with one having a larger buffer width
-- mymodule.lua

-- Define a variable to control whether to equalize on window navigation
local equalize_enabled = false

-- Define a setter function for the equalize_enabled flag
local function set_equalize_enabled(value)
  equalize_enabled = value
end

-- Define a function to make windows equal width and increase buffer width
function equalize_windows_and_increase_width()
    -- Make windows equal width
    vim.cmd("wincmd =")

    -- Increase buffer width by 40 columns
    vim.cmd("vertical resize +80")
end

return {
  equalize_windows_and_increase_width = equalize_windows_and_increase_width,
  set_equalize_enabled = set_equalize_enabled
}

-- Define a function to make windows equal width and increase buffer width
M = {}


M.isWide = false
M.widen = function()

    local width = vim.fn.winwidth(0) * .5

    -- Make windows equal width
    vim.cmd("wincmd =")

    -- Increase buffer width by the calculated width
    vim.cmd("vertical resize +" .. width)
end

return M

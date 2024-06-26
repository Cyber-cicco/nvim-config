local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

if not vim.g.vscode then
    vim.keymap.set("n", "<leader>a", mark.add_file)
    vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

    vim.keymap.set("n", "&", function() ui.nav_file(1) end)
    vim.keymap.set("n", "é", function() ui.nav_file(2) end)
    vim.keymap.set("n", '"', function() ui.nav_file(3) end)
    vim.keymap.set("n", "'", function() ui.nav_file(4) end)
    vim.keymap.set("n", "(", function() ui.nav_file(5) end)
    vim.keymap.set("n", "-", function() ui.nav_file(6) end)
end

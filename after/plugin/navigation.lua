local harpoon = require("harpoon")
local conf = require("telescope.config").values
local teleproompter = require("teleproompter")
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')

-- REQUIRED
harpoon:setup()
local proompt = teleproompter.setup()
-- REQUIRED

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                -- Get the selection AFTER user presses Enter
                local selection = action_state.get_selected_entry()
                local file_path = selection and selection.path

                -- Close telescope first
                require('telescope.actions').close(prompt_bufnr)

                -- If we have a valid file path, open it then add to Harpoon
                if file_path then
                    vim.notify("Adding to Harpoon: " .. file_path)
                    -- Open the file
                    vim.cmd('edit ' .. file_path)
                    -- Add current buffer to Harpoon
                    vim.defer_fn(function()
                        harpoon:list():add()
                    end, 100)
                end
            end)
            return true
        end
    })
end, {})

vim.keymap.set('n', '<C-p>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    builtin.grep_string({ search = vim.fn.input("Grep >") });
end)
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
    harpoon:list(proompt.lists.resources_list):add()
end)
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>d", function() harpoon:list():clear() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

vim.keymap.set("n", "&", function() harpoon:list():select(1) end)
vim.keymap.set("n", "é", function() harpoon:list():select(2) end)
vim.keymap.set("n", '"', function() harpoon:list():select(3) end)
vim.keymap.set("n", "'", function() harpoon:list():select(4) end)
vim.keymap.set("n", "(", function() harpoon:list():select(5) end)
vim.keymap.set("n", "-", function() harpoon:list():select(6) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>P", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>N", function() harpoon:list():next() end)

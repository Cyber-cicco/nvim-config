local harpoon = require("harpoon")
local conf = require("telescope.config").values
local teleproompter = require("teleproompter")
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')

-- REQUIRED
harpoon:setup()
local proompt = teleproompter.setup({
    -- System prompt configuration
    system_prompt_file = vim.fn.stdpath("config") .. "/teleproompter_system_prompt.md",
    default_system_prompt = [[
<styles_info>

Claude is an expert coding assistant with deep knowledge of software development and best practices. His is to analyze the provided information and help the user improve his codebase, and create features.

## Guidelines

1. **Code Analysis**: Claude first analyzes any code the user shares, understanding its structure, purpose, and potential issues.

2. **Context Awareness**: Claude pays close attention to the context provided, which may include project requirements, constraints, and specific areas of concern. If he feels like there is missing context, he should ask for the files, rather than trying to guess what it looks like.

3. **Improvement Focus**: When suggesting improvements, Claude focuses on:
   - Performance optimization
   - Idiomatic code
   - Error handling and edge cases
   - Testing strategies

4. **Implementation Details**: When providing code solutions, Claude includes:
   - Clear explanations of his reasoning
   - Complete implementations (not just snippets)
   - Consideration of edge cases
   - Comments for complex sections

5. **Priority**: If the user has shared many files or concerns, Claude prioritizes addressing the most critical issues first.

6. **Learning Orientation**: Claude explains his thought process and teaches the user the principles behind his suggestions rather than just providing solutions.

</styles_info>
    ]]

})
-- REQUIRED

vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                -- Get the selection AFTER user presses Enter
                local selection = action_state.get_selected_entry()
                if not selection then return end

                local file_path = selection.path

                -- Close telescope first
                require('telescope.actions').close(prompt_bufnr)

                -- If we have a valid file path, open it then add to Harpoon
                if file_path then
                    -- Open the file first
                    vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
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
    harpoon:list("__teleproompter_resources_list__"):add()
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

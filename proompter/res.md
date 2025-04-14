### Context :  ###

This is my neovim config. I'm currently customizing it to implement LLMs into my workflow


### Command Output 1: tree . ###

.
├── after
│   └── plugin
│       ├── autotag.lua
│       ├── cmp.lua
│       ├── colors.lua
│       ├── fugitive.lua
│       ├── gopher.lua
│       ├── harpoon.lua
│       ├── icons.lua
│       ├── lsp.lua
│       ├── lualine.lua
│       ├── nodzcript-lsp.lua
│       ├── null-ls.lua
│       ├── nvim-tree.lua
│       ├── rust-tools.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       └── undotree.lua
├── archive
│   └── telescope.txt
├── init.lua
├── lua
│   └── hijokaidan
│       ├── filetypes.lua
│       ├── packer_compiled.lua
│       ├── packer.lua
│       ├── remap.lua
│       └── set.lua
├── nvim-tree-lua.txt
├── plugin
├── proompter
│   ├── ctx_main.md
│   ├── inst_harpoon.md
│   └── res.md
└── sessionizer.sh

7 directories, 28 files


### after/plugin/harpoon.lua ###

local harpoon = require("harpoon")
local conf = require("telescope.config").values
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

local CMD = "__teleproompter_context_list__"

local CONTEXT = "__teleproompter_context_list__"
local CMD_CONTEXT = "__teleproompter_cmd_context_list__"
local RESOURCES = "__teleproompter_resources_list__"
local INSTRUCTIONS = "__teleproompter_instructions_list__"

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>c", function() harpoon:list(CONTEXT):add() end)
vim.keymap.set("n", "<leader>r", function() harpoon:list(RESOURCES):add() end)
vim.keymap.set("n", "<leader>i", function() harpoon:list(INSTRUCTIONS):add() end)
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>lc", function() harpoon.ui:toggle_quick_menu(harpoon:list(CONTEXT)) end)
vim.keymap.set("n", "<leader>lt", function() harpoon.ui:toggle_quick_menu(harpoon:list(CMD_CONTEXT)) end)
vim.keymap.set("n", "<leader>lr", function() harpoon.ui:toggle_quick_menu(harpoon:list(RESOURCES)) end)
vim.keymap.set("n", "<leader>li", function() harpoon.ui:toggle_quick_menu(harpoon:list(INSTRUCTIONS)) end)
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

-- Function to copy contents of all items in lists to clipboard
local function copy_all_items_to_clipboard()
    local all_contents = {}
    
    -- Get items from CONTEXT list
    for _, item in ipairs(harpoon:list(CONTEXT).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### Context : " .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Get items from RESOURCES list
    for _, item in ipairs(harpoon:list(RESOURCES).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### " .. file_path .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Get items from INSTRUCTIONS list
    for _, item in ipairs(harpoon:list(INSTRUCTIONS).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### Instructions : " .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Join all contents and copy to clipboard
    local combined_content = table.concat(all_contents, "")
    vim.fn.setreg("+", combined_content)
    vim.notify("Copied contents of all items to clipboard")
end

-- Add keybinding for copying all items
vim.keymap.set("n", "<leader>yc", copy_all_items_to_clipboard, { desc = "Copy contents of all marked files to clipboard" })

-- Function to add a command to the CMD_CONTEXT list
local function add_command_to_list()
    vim.ui.input({ prompt = "Enter command: " }, function(cmd)
        if cmd and cmd ~= "" then
            harpoon:list(CMD_CONTEXT):append({
                value = cmd,
                context = { cmd = cmd }
            })
            vim.notify("Added command to CMD_CONTEXT list: " .. cmd)
        end
    end)
end

-- Function to execute commands from CMD_CONTEXT list and copy output to clipboard
local function execute_commands_and_copy_output()
    local all_outputs = {}
    
    for i, item in ipairs(harpoon:list(CMD_CONTEXT).items) do
        local cmd = item.value
        vim.notify("Executing command: " .. cmd)
        
        local output = vim.fn.system(cmd)
        if output then
            table.insert(all_outputs, "### Command " .. i .. ": " .. cmd .. " ###\n\n" .. output .. "\n\n")
        else
            table.insert(all_outputs, "### Command " .. i .. ": " .. cmd .. " ###\n\n" .. "[No output or error occurred]\n\n")
        end
    end
    
    if #all_outputs > 0 then
        local combined_output = table.concat(all_outputs, "")
        vim.fn.setreg("+", combined_output)
        vim.notify("Copied output of all commands to clipboard")
    else
        vim.notify("No commands found in CMD_CONTEXT list")
    end
end

-- Function to copy everything (files content + command outputs)
local function copy_everything_to_clipboard()
    local all_contents = {}
    
    -- Get items from CONTEXT list
    for _, item in ipairs(harpoon:list(CONTEXT).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### Context : " .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Get command outputs from CMD_CONTEXT list
    for i, item in ipairs(harpoon:list(CMD_CONTEXT).items) do
        local cmd = item.value
        local output = vim.fn.system(cmd)
        if output then
            table.insert(all_contents, "### Command Output " .. i .. ": " .. cmd .. " ###\n\n" .. output .. "\n\n")
        end
    end
    
    -- Get items from RESOURCES list
    for _, item in ipairs(harpoon:list(RESOURCES).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### " .. file_path .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Get items from INSTRUCTIONS list
    for _, item in ipairs(harpoon:list(INSTRUCTIONS).items) do
        local file_path = item.value
        local file = io.open(file_path, "r")
        if file then
            local content = file:read("*all")
            file:close()
            table.insert(all_contents, "### Instructions : " .. " ###\n\n" .. content .. "\n\n")
        end
    end
    
    -- Join all contents and copy to clipboard
    local combined_content = table.concat(all_contents, "")
    vim.fn.setreg("+", combined_content)
    vim.notify("Copied all content and command outputs to clipboard")
end

-- Add keybindings for the new functions
vim.keymap.set("n", "<leader>tc", add_command_to_list, { desc = "Add command to CMD_CONTEXT list" })
vim.keymap.set("n", "<leader>ye", execute_commands_and_copy_output, { desc = "Execute commands and copy output to clipboard" })
vim.keymap.set("n", "<leader>ya", copy_everything_to_clipboard, { desc = "Copy all content and command outputs to clipboard" })

-- NEW FUNCTIONS FOR ALL LISTS WINDOW
-- Function to display all lists in a single window
local function show_all_lists_window()
    -- Create a new buffer for our window
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Prepare the content for all lists
    local content = {}
    
    -- Add header
    table.insert(content, "PROMPT FILES LIST")
    table.insert(content, "================")
    table.insert(content, "")
    
    -- INSTRUCTIONS list
    table.insert(content, "INSTRUCTIONS LIST:")
    table.insert(content, "-----------------")
    local instructions_items = harpoon:list(INSTRUCTIONS).items
    if #instructions_items > 0 then
        for i, item in ipairs(instructions_items) do
            table.insert(content, string.format("%d. %s", i, item.value))
        end
    else
        table.insert(content, "No items in INSTRUCTIONS list")
    end
    table.insert(content, "")
    
    -- CONTEXT list
    table.insert(content, "CONTEXT LIST:")
    table.insert(content, "------------")
    local context_items = harpoon:list(CONTEXT).items
    if #context_items > 0 then
        for i, item in ipairs(context_items) do
            table.insert(content, string.format("%d. %s", i, item.value))
        end
    else
        table.insert(content, "No items in CONTEXT list")
    end
    table.insert(content, "")
    
    -- RESOURCES list
    table.insert(content, "RESOURCES LIST:")
    table.insert(content, "--------------")
    local resources_items = harpoon:list(RESOURCES).items
    if #resources_items > 0 then
        for i, item in ipairs(resources_items) do
            table.insert(content, string.format("%d. %s", i, item.value))
        end
    else
        table.insert(content, "No items in RESOURCES list")
    end
    table.insert(content, "")
    
    -- CMD_CONTEXT list
    table.insert(content, "COMMAND CONTEXT LIST:")
    table.insert(content, "---------------------")
    local cmd_context_items = harpoon:list(CMD_CONTEXT).items
    if #cmd_context_items > 0 then
        for i, item in ipairs(cmd_context_items) do
            table.insert(content, string.format("%d. %s", i, item.value))
        end
    else
        table.insert(content, "No items in CMD_CONTEXT list")
    end
    
    -- Add footer with keybindings help
    table.insert(content, "")
    table.insert(content, "Press 'q' to close this window")
    
    -- Set the content to the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    -- Calculate window size and position
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_width = math.min(width - 4, 80)
    local win_height = math.min(height - 4, 40)
    local row = (height - win_height) / 2
    local col = (width - win_width) / 2
    
    -- Window options
    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    }
    
    -- Create the window
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Set window options
    vim.api.nvim_win_set_option(win, "winblend", 0)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    
    -- Add keymaps for the window
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":lua vim.api.nvim_win_close(" .. win .. ", true)<CR>", {
        noremap = true,
        silent = true
    })
    
    -- Set buffer name
    vim.api.nvim_buf_set_name(buf, "Harpoon Lists")
    
    -- Apply highlighting for better readability
    vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, "Special", 1, 0, -1)
    
    local line_idx = 4
    vim.api.nvim_buf_add_highlight(buf, -1, "Keyword", line_idx, 0, -1)
    line_idx = line_idx + 1
    vim.api.nvim_buf_add_highlight(buf, -1, "Comment", line_idx, 0, -1)
    
    -- Find and highlight other section headers
    for i, line in ipairs(content) do
        if line:match("^[A-Z]+ LIST:$") then
            vim.api.nvim_buf_add_highlight(buf, -1, "Keyword", i - 1, 0, -1)
            vim.api.nvim_buf_add_highlight(buf, -1, "Comment", i, 0, -1)
        end
    end
end

-- Add keybinding to show all lists in one window
vim.keymap.set("n", "<leader>la", show_all_lists_window, { desc = "Show all harpoon lists in one window" })

-- Function to open a more interactive window with telescope
local function show_all_lists_telescope()
    local combined_items = {}
    
    -- Collect items from all lists with their list type
    for _, item in ipairs(harpoon:list(INSTRUCTIONS).items) do
        table.insert(combined_items, { value = item.value, type = "INSTRUCTIONS" })
    end
    
    for _, item in ipairs(harpoon:list(CONTEXT).items) do
        table.insert(combined_items, { value = item.value, type = "CONTEXT" })
    end
    
    for _, item in ipairs(harpoon:list(RESOURCES).items) do
        table.insert(combined_items, { value = item.value, type = "RESOURCES" })
    end
    
    for _, item in ipairs(harpoon:list(CMD_CONTEXT).items) do
        table.insert(combined_items, { value = item.value, type = "CMD_CONTEXT" })
    end
    
    -- Prepare results for telescope
    local results = {}
    for _, item in ipairs(combined_items) do
        table.insert(results, string.format("[%s] %s", item.type, item.value))
    end
    
    -- Open telescope with combined items
    require("telescope.pickers").new({}, {
        prompt_title = "All Harpoon Lists",
        finder = require("telescope.finders").new_table({
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            -- Action on selection: open the file or execute the command
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            
            -- Custom action to handle selection
            local function handle_selection()
                local selection = action_state.get_selected_entry()
                if selection and selection.value then
                    -- Close the picker
                    actions.close(prompt_bufnr)
                    
                    -- Parse the selection to get type and value
                    local type_pattern = "%[([^%]]+)%]"
                    local type_match = string.match(selection.value, type_pattern)
                    
                    -- Extract the actual value (everything after the type bracket)
                    local value = string.gsub(selection.value, "%[" .. type_match .. "%] ", "")
                    
                    if type_match == "CMD_CONTEXT" then
                        -- For commands, execute them
                        vim.notify("Executing command: " .. value)
                        local output = vim.fn.system(value)
                        -- Display output in a floating window
                        local lines = {}
                        for line in string.gmatch(output, "[^\r\n]+") do
                            table.insert(lines, line)
                        end
                        
                        -- Create temporary buffer for output
                        local buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                        
                        -- Calculate window size and position
                        local width = vim.api.nvim_get_option("columns")
                        local height = vim.api.nvim_get_option("lines")
                        local win_width = math.min(width - 4, 80)
                        local win_height = math.min(height - 4, 20)
                        local row = (height - win_height) / 2
                        local col = (width - win_width) / 2
                        
                        local opts = {
                            relative = "editor",
                            width = win_width,
                            height = win_height,
                            row = row,
                            col = col,
                            style = "minimal",
                            border = "rounded"
                        }
                        
                        local win = vim.api.nvim_open_win(buf, true, opts)
                        vim.api.nvim_buf_set_option(buf, "modifiable", false)
                        vim.api.nvim_buf_set_keymap(buf, "n", "q", 
                            ":lua vim.api.nvim_win_close(" .. win .. ", true)<CR>", 
                            { noremap = true, silent = true })
                    else
                        -- For file paths, open the file
                        vim.cmd("edit " .. value)
                    end
                end
            end
            
            -- Map enter key to our custom action
            map("i", "<CR>", handle_selection)
            map("n", "<CR>", handle_selection)
            
            return true
        end,
    }):find()
end

-- Add keybinding for telescope view of all lists
vim.keymap.set("n", "<leader>ls", show_all_lists_telescope, { desc = "Show all harpoon lists in telescope" })


### init.lua ###

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("hijokaidan.remap")
require("hijokaidan.set")
require("hijokaidan.filetypes")
if not vim.g.vscode then
  require("hijokaidan.packer_compiled")
end



### Instructions :  ###

Organize the harpoon functions into a separate plugin with harpoon and it's dependencies as a dependency




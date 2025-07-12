local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local previewers = require('telescope.previewers')

-- Original keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>ga", ":Git blame<CR>");
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>");
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>");

-- Custom function to checkout commit
local function checkout_commit(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if not selection then return end
    
    actions.close(prompt_bufnr)
    
    -- Extract commit hash from selection
    local commit_hash = selection.value
    
    -- Confirm checkout
    local confirm = vim.fn.input("Checkout commit " .. commit_hash:sub(1, 8) .. "? (y/N): ")
    if confirm:lower() == 'y' or confirm:lower() == 'yes' then
        vim.cmd('Git checkout ' .. commit_hash)
        print("\nChecked out commit: " .. commit_hash:sub(1, 8))
    end
end

-- Custom function to checkout file at specific commit
local function checkout_file_at_commit(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if not selection then return end
    
    actions.close(prompt_bufnr)
    
    local commit_hash = selection.value
    local current_file = vim.fn.expand('%:p')
    
    if current_file == '' then
        print("No file currently open")
        return
    end
    
    -- Get relative path from git root
    local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
    local relative_path = current_file:gsub(git_root .. '/', '')
    
    local confirm = vim.fn.input("Checkout " .. relative_path .. " at commit " .. commit_hash:sub(1, 8) .. "? (y/N): ")
    if confirm:lower() == 'y' or confirm:lower() == 'yes' then
        vim.cmd('Git checkout ' .. commit_hash .. ' -- ' .. vim.fn.shellescape(relative_path))
        print("\nChecked out " .. relative_path .. " at commit: " .. commit_hash:sub(1, 8))
        -- Reload the buffer
        vim.cmd('checktime')
    end
end

-- Function to show commits with checkout action
local function git_commits_with_checkout()
    builtin.git_commits({
        attach_mappings = function(prompt_bufnr, map)
            -- Override default enter action
            actions.select_default:replace(checkout_commit)
            
            -- Add alternative mapping for checkout
            map('i', '<C-o>', checkout_commit)
            map('n', '<C-o>', checkout_commit)
            
            return true
        end
    })
end

-- Function to show commits for current file with checkout action
local function git_file_commits_with_checkout()
    local current_file = vim.fn.expand('%:p')
    if current_file == '' then
        print("No file currently open")
        return
    end
    
    builtin.git_bcommits({
        attach_mappings = function(prompt_bufnr, map)
            -- Override default enter action for file checkout
            actions.select_default:replace(checkout_file_at_commit)
            
            -- Add alternative mapping
            map('i', '<C-o>', checkout_file_at_commit)
            map('n', '<C-o>', checkout_file_at_commit)
            
            return true
        end
    })
end

-- Enhanced function with better preview and more options
local function enhanced_git_commits()
    pickers.new({}, {
        prompt_title = "Git Commits (Enter to checkout)",
        finder = finders.new_oneshot_job({
            "git", "log", 
            "--oneline", 
            "--graph", 
            "--color=never",
            "--pretty=format:%h %s (%an, %ar)"
        }, {
            entry_maker = function(line)
                local hash = line:match("^%s*[│├└│]*%s*([a-f0-9]+)")
                if not hash then return nil end
                
                return {
                    value = hash,
                    display = line,
                    ordinal = line,
                }
            end
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_termopen_previewer({
            get_command = function(entry)
                return {"git", "show", "--color=always", entry.value}
            end
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(checkout_commit)
            
            -- Additional mappings
            map('i', '<C-o>', checkout_commit)
            map('n', '<C-o>', checkout_commit)
            map('i', '<C-d>', function()
                local selection = action_state.get_selected_entry()
                if selection then
                    actions.close(prompt_bufnr)
                    vim.cmd('Git show ' .. selection.value)
                end
            end)
            
            return true
        end
    }):find()
end

-- New keymaps for commit browsing and checkout
vim.keymap.set("n", "<leader>gl", git_commits_with_checkout, { desc = "Git log with checkout" })
vim.keymap.set("n", "<leader>gL", enhanced_git_commits, { desc = "Enhanced git log with checkout" })
vim.keymap.set("n", "<leader>gf", git_file_commits_with_checkout, { desc = "Git file history with checkout" })

-- Additional useful git telescope commands
vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gco", builtin.git_branches, { desc = "Git checkout branch" })

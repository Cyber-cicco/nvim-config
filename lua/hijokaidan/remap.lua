--Set of the leader
vim.g.mapleader =  " "

local gocap = "~/go/bin/gocap"

--Yanking configuration
vim.keymap.set("x", "<A-p>", '"_dP')
vim.keymap.set({"n", "v"}, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", [["+Y]])

--NvimTree Remaps 
vim.keymap.set("n", "<leader>po", ":NvimTreeOpen<CR>")
vim.keymap.set("n", "<leader>pc", ":NvimTreeClose<CR>")

-- Prevent the ynaking if the char when sdeleting it.
vim.keymap.set("n", "x", '"_x')

-- Selecting all the page with ctrl a
vim.keymap.set("n", "<C-g>", 'gg<S-v>G')

--Split window
vim.keymap.set("n", "ss", ':sp<CR><C-w>w')
vim.keymap.set("n", "sv", ':vs<CR><C-w>w')

--Move between windows
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<Tab>', '<C-w>w')


--Resize window
vim.keymap.set('n', '<C-h>', '<C-w><')
vim.keymap.set('n', '<C-j>', '<C-w>-')
vim.keymap.set('n', '<C-k>', '<C-w>+')
vim.keymap.set('n', '<C-l>', '<C-w>>')

--Quit window
vim.keymap.set('n', '<S-q>', ':wq<CR>')

--Movements remap
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')


--Add parenthesis and curly brackets
vim.keymap.set("i", "{", "{}<ESC>i")
vim.keymap.set("i", "(", "()<ESC>i")
vim.keymap.set("i", "[", "[]<ESC>i")
vim.keymap.set("i", '"', '""<ESC>i')
vim.keymap.set("i", "<C-c>", "{<CR>}<ESC>O")
vim.keymap.set("i", "<C-f>", "()<ESC>i")

-- Replacements and searches
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]);
vim.keymap.set("n", "<leader>f", [[/<C-r><C-w><CR>]]);

-- React Snippets
vim.keymap.set("n", "<leader>rs", "i style={}<ESC>i")
vim.keymap.set("n", "<leader>rt", "i <Text style={App_Style.text}></Text><ESC>F<i")

-- Navigation with tmux
vim.keymap.set("n", "<C-p>", ":silent !tmux neww ~/sessionizer.sh<CR>")
vim.keymap.set("n", "<leader>t", ":silent !~/floating_terminal.sh<CR>")
vim.keymap.set("n", "<C-S>", ":silent !rofi.sh<CR>")
vim.keymap.set("n", "<C-c>", ":silent !tmux neww ~/cheat_search.sh<CR>")

--SQL Snippets
vim.keymap.set("n", "<leader>qc", "iCREATE TABLE nom_table(<CR>)<ESC>%hvb")
vim.keymap.set("n", "<leader>qr", "inom_champ type_champ,<ESC>bbevb")
vim.keymap.set("n", "<leader>qp", "iid INT(6) PRIMARY KEY NOT NULL,<ESC>")

--Thymeleaf Snippets
vim.keymap.set("i", "<C-t>b", "<th:block></th:block><ESC>F>i")
vim.keymap.set("i", "<C-t>n", '<th:block th:replace="~{}"></th:block><ESC>F}i')
vim.keymap.set("i", "<C-t>r", 'th:replace="~{}"<ESC>F}i')
vim.keymap.set("i", "<C-t>e", '<th:block th:each="el, iterStat : ${}"><th:block><ESC>F}i')
--
--Go Snippets
vim.keymap.set("i", "<C-g>e", "if err != nil {<CR>return err<CR>}")

-- PHP Snippets
vim.keymap.set({"n"}, "<leader>qc", ":!~/go/bin/gocap json-ctrl -e -n ")
vim.keymap.set({"n"}, "<leader>qh", ":!~/go/bin/gocap html-ctrl -e -n ")
vim.keymap.set({"n"}, "<leader>qd", ":!~/go/bin/gocap dto -n ")
vim.keymap.set({"n"}, "<leader>qs", ":!~/go/bin/gocap srv -e -n ")
vim.keymap.set({"n"}, "<leader>qv", ":!~/go/bin/gocap validator -n ")

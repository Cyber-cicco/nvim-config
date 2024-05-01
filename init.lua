vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("hijokaidan.remap")
require("hijokaidan.set")
if not vim.g.vscode then
  require("hijokaidan.packer_compiled")
end


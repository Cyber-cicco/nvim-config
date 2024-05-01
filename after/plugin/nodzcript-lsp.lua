local lsp = require('lsp-zero').preset({})
local client = vim.lsp.start_client {
    name = "nodzcript-lsp",
    cmd = { "/home/hijokaidan/PC/golang/nodzcript-lsp/nodzcript-lsp" },
    on_attach = lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
    end),
}

if not client then
    vim.notify("client didn't start as expected")
    return
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function ()
        vim.lsp.buf_attach_client(0, client)
    end
})

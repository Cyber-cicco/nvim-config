function Col(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

end
if not vim.g.vscode then
    Col();
end

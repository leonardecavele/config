-- Enable TreeSitter when a buffer is open
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
	callback = function()
		vim.schedule(function()
			vim.cmd("TSBufEnable highlight")
		end)
	end,
})

-- https://github.com/farmergreg/vim-lastplace
local lastplace_ok, lastplace = pcall(require, 'lastplace')
if lastplace_ok then
  lastplace.setup({
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase" },
    lastplace_open_folds = true,
  })
end

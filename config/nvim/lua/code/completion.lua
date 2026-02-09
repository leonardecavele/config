-- https://github.com/nvim-mini/mini.completion
local mini_ok, mini_completion = pcall(require, "mini.completion")
if mini_ok then
  mini_completion.setup()

  -- Toggle mini.completion ON/OFF
  vim.g.mini_completion_enabled = true

  vim.keymap.set('n', '<leader>tc', function()
    vim.g.mini_completion_enabled = not vim.g.mini_completion_enabled

    if vim.g.mini_completion_enabled then
      pcall(vim.api.nvim_del_augroup_by_name, "MiniCompletion")
      mini_completion.setup()
      print("mini.completion: ON")
    else
      pcall(vim.api.nvim_del_augroup_by_name, "MiniCompletion")
      print("mini.completion: OFF")
    end
  end, { desc = "Toggle mini.completion" })
end

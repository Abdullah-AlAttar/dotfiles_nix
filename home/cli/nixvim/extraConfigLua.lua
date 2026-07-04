-- Custom Neovim configuration in Lua

-- Right-to-left (RTL) text support — toggle with <leader>rt (keymaps in keymappings.nix)
local rtl_enabled = false

function _G.toggle_rtl()
  rtl_enabled = not rtl_enabled
  if rtl_enabled then
    vim.opt.rightleft = true
    vim.opt.rightleftcmd = 'search'
    vim.opt.termbidi = true
    vim.notify('RTL mode enabled', vim.log.levels.INFO)
  else
    vim.opt.rightleft = false
    vim.opt.rightleftcmd = ''
    vim.opt.termbidi = false
    vim.notify('RTL mode disabled', vim.log.levels.INFO)
  end
end

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',  -- Highlight group to use
      timeout = 300,          -- Duration in milliseconds
    })
  end,
})

local lsp_format_group = vim.api.nvim_create_augroup('lsp-format-on-save', { clear = true })

local function format_current_buffer(bufnr)
  vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

vim.api.nvim_create_user_command('Format', function()
  format_current_buffer(vim.api.nvim_get_current_buf())
end, {
  bar = true,
  desc = 'Format the current buffer with attached LSP clients',
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Format supported buffers before save',
  group = lsp_format_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if not client or not client:supports_method('textDocument/formatting', bufnr) then
      return
    end

    vim.api.nvim_clear_autocmds({
      group = lsp_format_group,
      buffer = bufnr,
      event = 'BufWritePre',
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp_format_group,
      buffer = bufnr,
      desc = 'Format current buffer before save',
      callback = function()
        format_current_buffer(bufnr)
      end,
    })
  end,
})

-- :Chat — open toggleterm with reasonix (usage: nvim -c Chat)
vim.api.nvim_create_user_command('Chat', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local cmd = Terminal:new({ cmd = 'reasonix' })
  cmd:toggle()
end, { desc = 'Open toggleterm with reasonix' })

-- :Crush — open toggleterm with crush (usage: nvim -c Crush)
vim.api.nvim_create_user_command('Crush', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local cmd = Terminal:new({ cmd = 'crush' })
  cmd:toggle()
end, { desc = 'Open toggleterm with crush' })

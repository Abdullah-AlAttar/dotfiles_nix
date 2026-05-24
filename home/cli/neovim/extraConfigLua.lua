-- Custom Neovim configuration in Lua

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

-- Neovide-specific keymappings for scaling
if vim.g.neovide then
    vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

    vim.g.neovide_opacity = 0.98
    vim.g.neovide_normal_opacity = 0.98
end

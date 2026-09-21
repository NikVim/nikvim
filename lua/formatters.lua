-- Per-filetype formatprg override, so gq/gqq shell out to an external
-- formatter instead of going through formatexpr/LSP. Filetypes with no
-- entry here are left untouched. "%s" is replaced with the buffer's
-- shell-escaped path: stylua resolves stylua.toml by searching upward
-- from that path, not from Neovim's cwd, so without it a buffer opened
-- outside the project root silently formats with stylua's defaults.
local formatters = {
  lua = "stylua --stdin-filepath %s -",
}

-- The sentinel Neovim's LSP client assigns to 'formatexpr' on attach.
local lsp_formatexpr = "v:lua.vim.lsp.formatexpr()"

local augroup = vim.api.nvim_create_augroup("nikvim_formatters", {})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local template = formatters[vim.bo[args.buf].filetype]
    if not template then
      return
    end

    -- Binary missing: leave formatprg unset so gq/gqq fall back to
    -- formatexpr/LSP instead of failing on a missing command.
    local bin = template:match("^%S+")
    if vim.fn.executable(bin) ~= 1 then
      return
    end

    local path = vim.fn.shellescape(vim.api.nvim_buf_get_name(args.buf))
    vim.bo[args.buf].formatprg = template:format(path)

    -- 'formatexpr' takes priority over 'formatprg' when both are set. A
    -- client already running for another buffer attaches to this one
    -- synchronously within this same FileType event, which can set
    -- 'formatexpr' before this callback runs and would otherwise
    -- silently override the formatter above.
    if vim.bo[args.buf].formatexpr == lsp_formatexpr then
      vim.bo[args.buf].formatexpr = nil
    end
  end,
})

-- Per-filetype formatprg override, so gq/gqq shell out to an external
-- formatter instead of going through formatexpr/LSP. Filetypes with no
-- entry here are left untouched.
local formatters = {
  lua = "stylua -",
}

local augroup = vim.api.nvim_create_augroup("nikvim_formatters", {})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local formatprg = formatters[vim.bo[args.buf].filetype]
    if not formatprg then
      return
    end

    -- Binary missing: leave formatprg unset so gq/gqq fall back to
    -- formatexpr/LSP instead of failing on a missing command.
    local bin = formatprg:match("^%S+")
    if vim.fn.executable(bin) ~= 1 then
      return
    end

    vim.bo[args.buf].formatprg = formatprg
  end,
})

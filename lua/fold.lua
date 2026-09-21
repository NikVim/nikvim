local opt = vim.opt

-- Folds start open, not collapsed, when a buffer is displayed
opt.foldenable = true
opt.foldlevelstart = 99
opt.foldcolumn = "1"

-- Treesitter folding by default. vim.treesitter.foldexpr() already returns
-- fold level 0 for every line when no parser is available, so this is a
-- safe global default; see below for buffers that genuinely need to diverge.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Per-filetype foldmethod override. Only filetypes that actually need to
-- diverge from the default above belong here.
local overrides = {}

local function has_treesitter_parser(bufnr)
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  return ok and parser ~= nil
end

local augroup = vim.api.nvim_create_augroup("nikvim_fold", {})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local override = overrides[vim.bo[buf].filetype]

    if override then
      vim.wo[0][0].foldmethod = override
      return
    end

    -- No parser: the global treesitter default would just produce no
    -- folds, so fall back to indent, and flag the buffer as eligible for
    -- an LSP upgrade if a capable client attaches later.
    if not has_treesitter_parser(buf) then
      vim.wo[0][0].foldmethod = "indent"
      vim.b[buf].nikvim_fold_fallback = true
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    if not vim.b[buf].nikvim_fold_fallback then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/foldingRange", buf) then
      return
    end

    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    vim.b[buf].nikvim_fold_fallback = nil
  end,
})

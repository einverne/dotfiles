-- lua/config/autocmds.lua
-- 自动命令，迁移自原 .vimrc / python_vimrc。
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 文件类型专属缩进 (迁移自 .vimrc 与 python_vimrc)
autocmd("FileType", {
  group = augroup("indent_by_filetype", { clear = true }),
  pattern = { "yaml", "json", "javascript", "typescript", "html", "css", "scss", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

autocmd("FileType", {
  group = augroup("indent_python", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 79
    vim.opt_local.expandtab = true
  end,
})

-- 保存时去除 py / coffee 行尾空白 (原 DeleteTrailingWS)
autocmd("BufWritePre", {
  group = augroup("trim_trailing_ws", { clear = true }),
  pattern = { "*.py", "*.coffee" },
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- 打开文件时回到上次编辑的位置 (原 BufReadPost 跳转)
autocmd("BufReadPost", {
  group = augroup("last_position", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 1 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 复制文本时短暂高亮，友好的视觉反馈
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

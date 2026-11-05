-- Run from dotfiles: nvim --headless -u NONE -i NONE -l .config/nvim/tests/obsidian_completion.lua
local config = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
vim.opt.rtp:prepend(config)
for _, plugin in ipairs({ 'plenary.nvim', 'obsidian.nvim' }) do
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/' .. plugin)
end
local vault = vim.fn.tempname()
vim.fn.mkdir(vault .. '/Template', 'p')
vim.fn.mkdir(vault .. '/nested', 'p')
local function write(path, lines)
  vim.fn.writefile(lines, vault .. '/' .. path)
end
-- Broad body matches used to load every file and flood the completion menu.
for i = 1, 1200 do
  write(string.format('note-%04d.md', i), { '# Note ' .. i, 'java ne 的' })
end
write('Java.md', { '---', 'aliases: [JVM, 咖啡语言]', 'title: Java language', '---', '# Runtime', 'A block ^example' })
write('nested/Java.md', { '# Java duplicate' })
write('Template/Java-template.md', { '# Excluded template' })
write('current.md', { '# Local heading', 'local block ^local' })
local function run()
  require('obsidian').setup({
    workspaces = { { name = 'test', path = vault } },
    legacy_commands = false,
    cache = { enabled = true, backend = 'memory' },
    templates = { folder = 'Template' },
    ui = { enable = false },
    footer = { enabled = false },
    frontmatter = { enabled = false },
  })
  local cache = require('obsidian.cache')
  assert(vim.wait(5000, cache.is_ready, 10), 'cache did not become ready')
  local search = require('obsidian.search')
  local full_search = search.find_notes_async
  local fix = require('config.obsidian_completion')
  fix.setup()
  local refs = require('obsidian.completion.sources.refs')
  local process = refs.process_completion
  fix.setup()
  assert(refs.process_completion == process, 'setup must be idempotent')
  local succeeded = pcall(refs.process_completion, function() error('expected callback failure') end, {
    cursor_before_line = 'plain text', cursor_after_line = '', character = 10,
  })
  assert(not succeeded and search.find_notes_async == full_search, 'general search must be restored after errors')
  vim.cmd('edit ' .. vim.fn.fnameescape(vault .. '/current.md'))
  local Note = require('obsidian.note')
  local from_file, loads = Note.from_file, 0
  Note.from_file = function(...)
    loads = loads + 1
    return from_file(...)
  end
  local handler = require('obsidian.lsp.handlers.completion')
  local function complete(term)
    local text = '[[' .. term
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { text, '# Local heading', 'local block ^local' })
    local result, done
    loads = 0
    local start = vim.uv.hrtime()
    handler({ textDocument = { uri = vim.uri_from_bufnr(0) }, position = { line = 0, character = #text } }, function(err, res)
      assert(not err, vim.inspect(err))
      result, done = res, true
    end)
    assert(vim.wait(3000, function() return done end, 10), 'completion did not return: ' .. term)
    print(string.format('term=%s loads=%d items=%d ms=%.1f', term, loads, #result.items, (vim.uv.hrtime() - start) / 1e6))
    assert(loads <= 30, 'completion read ' .. loads .. ' notes; expected at most 30')
    assert(search.find_notes_async == full_search, 'completion changed general search')
    return result.items
  end
  local function contains(items, fragment)
    for _, item in ipairs(items) do
      if item.textEdit and item.textEdit.newText:find(fragment, 1, true) then return true end
    end
    return false
  end
  complete('ne')
  complete('的')
  assert(contains(complete('note-'), 'note-'), 'filename completion missing')
  local java = complete('java')
  assert(contains(java, 'nested/Java'), 'duplicate filenames must be disambiguated')
  assert(not contains(java, 'Java-template'), 'templates leaked into completion')
  assert(contains(complete('JVM'), '|JVM'), 'alias completion missing')
  assert(contains(complete('咖啡'), '咖啡语言'), 'Chinese alias completion missing')
  assert(contains(complete('Java language'), '|Java language'), 'title completion must include a matching label')
  assert(contains(complete('Java#run'), '#runtime'), 'heading completion missing')
  assert(contains(complete('Java#^ex'), '#^example'), 'block completion missing')
  assert(contains(complete('#lo'), '#Local heading'), 'current-buffer heading completion missing')
  assert(contains(complete('#^lo'), '#^local'), 'current-buffer block completion missing')
  local new = complete('brand-new-note')
  assert(vim.iter(new):any(function(item) return item.command and item.command.command == 'obsidian.write_note' end), 'create-note action missing')
  local replies = {}
  loads = 0
  for _, term in ipairs({ 'note-', 'JVM' }) do
    local text = '[[' .. term
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { text })
    handler({ textDocument = { uri = vim.uri_from_bufnr(0) }, position = { line = 0, character = #text } }, function(_, res)
      replies[term] = res.items
    end)
  end
  assert(vim.wait(3000, function() return replies['note-'] and replies.JVM end, 10), 'overlapping requests did not return')
  assert(not contains(replies['note-'], 'note-0001'), 'stale request should not return references')
  assert(contains(replies.JVM, '|JVM') and loads <= 30, 'latest request should complete without processing stale matches')
  local done, found
  full_search('java', function(notes) found, done = #notes, true end, { search = { sort = false } })
  assert(vim.wait(5000, function() return done end, 10), 'full-text search did not return')
  assert(found > 1000, 'general full-text search was restricted')
  require('obsidian.cache').shutdown()
  assert(#complete('java') <= 1, 'cache disabled should not fall back to a full-vault search')
  print('PASS: bounded completion, aliases, titles, headings, blocks, duplicate names, templates, create-note action, and unrestricted full-text search')
end
local ok, err = xpcall(run, debug.traceback)
pcall(function() require('obsidian.cache').shutdown() end)
vim.fn.delete(vault, 'rf')
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd('cquit 1')
else
  vim.cmd('qa!')
end

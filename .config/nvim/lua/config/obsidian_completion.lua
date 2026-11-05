-- obsidian.nvim 3.16 的 refs 补全会全文搜索并读取所有命中笔记，尚未使用内置缓存。
-- 只为这条补全路径替换搜索：缓存中匹配文件名/标题/别名，最多读取 30 篇。
-- 继续复用插件的链接格式、同名消歧、标题/块补全；普通搜索保持原样。
local M = {}
local MAX_NOTES = 30
local BATCH_SIZE = 256
local generation = 0

local function find_completion_notes(term, callback, opts)
  local cache = require("obsidian.cache")
  local root = tostring(Obsidian.dir)
  generation = generation + 1
  local request_generation = generation
  -- refs 在调用搜索后不再访问搜索函数；推迟处理，让下面的临时替换先恢复。
  vim.schedule(function()
    -- 缓存还没就绪时不回退到全文扫描，继续输入即可再次触发补全。
    if not cache.is_ready() or tostring(Obsidian.dir) ~= root then
      callback({})
      return
    end

    local query = vim.fn.tolower(term)
    local template = Obsidian.opts.templates.folder
    local template_dir = template and vim.fs.normalize(root .. "/" .. template) .. "/"
    local rows = cache.notes.all()
    local paths = vim.tbl_keys(rows)
    local matches = {}
    local function match(path, row)
      if not template_dir or not vim.startswith(path, template_dir) then
        local stem = vim.fs.basename(path):gsub("%.[^.]+$", "")
        local labels = { stem, path:sub(#root + 2) }
        if row.properties and type(row.properties.title) == "string" then
          labels[#labels + 1] = row.properties.title
        end
        for _, alias in ipairs(row.aliases or {}) do
          labels[#labels + 1] = alias
        end

        local rank
        for _, label in ipairs(labels) do
          local value = vim.fn.tolower(label)
          local pos = value:find(query, 1, true)
          if pos then
            local score = value == query and 1 or (pos == 1 and 2 or 3)
            rank = math.min(rank or score, score)
          end
        end
        if rank then
          matches[#matches + 1] = { path = path, rank = rank }
        end
      end
    end

    local function finish()
      -- 精确匹配优先，宽泛查询的前 30 篇也保持稳定，继续输入可缩小范围。
      table.sort(matches, function(a, b)
        if a.rank ~= b.rank then
          return a.rank < b.rank
        end
        return a.path < b.path
      end)
      local notes = {}
      local Note = require("obsidian.note")
      local load_opts = vim.tbl_extend("keep", opts.notes or {}, { max_lines = Obsidian.opts.search.max_lines })
      for i = 1, math.min(MAX_NOTES, #matches) do
        local ok, note = pcall(Note.from_file, matches[i].path, load_opts)
        -- 缓存更新前文件可能已被删除或重命名，跳过即可。
        if ok then
          -- 插件 3.16 不把 YAML title 当作补全标签；仅在这份临时 Note 上补别名，
          -- 让按标题搜索得到的候选也能通过补全引擎的过滤，不改写笔记。
          if note.metadata and type(note.metadata.title) == "string" and note.metadata.title ~= "" then
            note:add_alias(note.metadata.title)
          end
          notes[#notes + 1] = note
        end
      end
      callback(notes)
    end

    -- 每批之间归还事件循环，连续输入时丢弃过期查询，避免堆积计算。
    local offset = 1
    local function step()
      if request_generation ~= generation or not cache.is_ready() or tostring(Obsidian.dir) ~= root then
        callback({})
        return
      end
      local last = math.min(offset + BATCH_SIZE - 1, #paths)
      for i = offset, last do
        local path = paths[i]
        if rows[path] then
          match(path, rows[path])
        end
      end
      offset = last + 1
      if offset <= #paths then
        vim.defer_fn(step, 0)
      else
        finish()
      end
    end
    step()
  end)
end

function M.setup()
  if M.configured then
    return
  end
  local refs = require("obsidian.completion.sources.refs")
  local search = require("obsidian.search")
  local process_completion = refs.process_completion
  refs.process_completion = function(callback, request)
    -- 3.16 的 refs 没有搜索后端配置入口。它会同步调用 find_notes_async 一次，
    -- 后续通过回调处理结果。只在这个同步调用期间替换，连异常路径也必须恢复。
    local find_notes_async = search.find_notes_async
    search.find_notes_async = find_completion_notes
    local ok, err = pcall(process_completion, callback, request)
    search.find_notes_async = find_notes_async
    if not ok then
      error(err)
    end
  end
  M.configured = true
end

return M

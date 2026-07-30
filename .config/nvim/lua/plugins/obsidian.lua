-- lua/plugins/obsidian.lua
-- obsidian.nvim：在 Neovim 里读写 ~/Sync 下的 Obsidian 仓库（笔记跳转、反链、日记、双链补全）。
-- 用社区维护版 obsidian-nvim/obsidian.nvim（原作者 epwalsh 的仓库已归档不再更新）。
--
-- 下面的选项都对着 ~/Sync/wiki/.obsidian/*.json 里的既有设置抄的，
-- 目的是让 Neovim 和 Obsidian App 对同一个仓库的行为保持一致，不要各写一套。
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- 跟 release 走，不跟 main（main 上有 3.18/4.0 的破坏性改动）
    -- 打开 markdown 才加载；:Obsidian 子命令也能按需唤醒插件
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- 显式声明，保证 obsidian 加载时 telescope 已就位（picker 用它）
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      -- 浏览 / 检索
      { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian 快速切换笔记" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian 全文搜索" },
      { "<leader>ok", "<cmd>Obsidian tags<cr>", desc = "Obsidian 按标签查找" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian 反向链接" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Obsidian 当前笔记的链接" },
      { "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Obsidian 大纲目录" },
      { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian 切换仓库" },
      -- 新建（<C-n> 见下方 config，只在 markdown buffer 里生效，等价于这里的 ,on）
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian 新建笔记" },
      { "<leader>oz", "<cmd>Obsidian unique_note<cr>", desc = "Obsidian 新建时间戳笔记" },
      { "<leader>oF", "<cmd>Obsidian template<cr>", desc = "Obsidian 插入模板" },
      -- 日记
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian 今天的日记" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian 昨天的日记" },
      { "<leader>oT", "<cmd>Obsidian tomorrow<cr>", desc = "Obsidian 明天的日记" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Obsidian 日记列表" },
      -- 编辑
      { "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Obsidian 切换待办勾选" },
      { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Obsidian 重命名笔记(同步更新反链)" },
      { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian 粘贴剪贴板图片" },
      -- 选区操作
      { "<leader>oL", "<cmd>Obsidian link<cr>", mode = "x", desc = "Obsidian 选区链接到已有笔记" },
      { "<leader>oN", "<cmd>Obsidian link_new<cr>", mode = "x", desc = "Obsidian 选区新建笔记并链接" },
      { "<leader>oe", "<cmd>Obsidian extract_note<cr>", mode = "x", desc = "Obsidian 选区抽成新笔记" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      -- 只保留 :Obsidian <子命令> 形式，旧的 :ObsidianXxx 在 4.0 会被移除
      legacy_commands = false,

      -- ~/Sync 下带 .obsidian/ 的几个仓库。第一个是默认仓库，
      -- 在某个仓库目录里打开 nvim 会自动切到对应 workspace。
      workspaces = {
        { name = "wiki", path = "~/Sync/wiki" },
        { name = "private", path = "~/Sync/private-wiki" },
        { name = "research", path = "~/Sync/Research-wiki" },
        { name = "japanese", path = "~/Sync/japanese-learning-notes" },
      },

      -- app.json: newFileFolderPath=Zettelkasten，新笔记统一落在这里
      notes_subdir = "Zettelkasten",
      new_notes_location = "notes_subdir",

      -- 文件名直接用标题原文。仓库里已有的笔记都是「齐格蒙 鲍曼.md」这种风格，
      -- 内置的 builtin.title_id 会转小写并把空格换成 -，和现状不一致。
      note_id_func = function(title)
        if title == nil or vim.trim(title) == "" then
          return require("obsidian.builtin").zettel_id()
        end
        return vim.trim(title)
      end,

      -- app.json: useMarkdownLinks=false（用 [[wiki 链接]]）、alwaysUpdateLinks=true
      link = {
        style = "wiki",
        format = "shortest",
        auto_update = true,
      },

      -- .obsidian/templates.json
      templates = {
        folder = "Template",
        date_format = "YYYY-MM-DD",
        time_format = "HH:mm:ss",
      },

      -- 新建笔记默认套 Jekyll 模板（博客那套 layout/tagline/category/cover 头）。
      -- 路径相对 templates.folder，即 Template/Jekyll Template.md。
      -- 作用范围：<C-n> 新建、,oN 选区建链接、,oe 选区抽笔记、补全里现场建笔记。
      -- 模板里的 YAML 会原样保留 —— 因为下面 frontmatter.enabled = false，
      -- 插件不会拿 id/aliases/tags 把它覆盖掉。
      -- 模板里的 title: "{{title}}" 会被自动填上笔记标题（{{title}} 也是 Obsidian
      -- 核心 Templates 插件认的占位符，App 那边套同一份模板同样生效）。
      note = {
        template = "Jekyll Template.md",
      },

      -- .obsidian/daily-notes.json
      daily_notes = {
        folder = "notes/journals",
        date_format = "YYYY-MM-DD",
        default_tags = {}, -- 现有日记没有 tags，别自动塞进去
        workdays_only = false, -- 周末也记，,ot 永远指今天而不是跳到下个工作日
        -- 故意不设 template：Template/Daily Template.md 用的是 Templater 的
        -- <% tp.file.title %> 语法，obsidian.nvim 只认 {{date}}/{{title}}，
        -- 套上去只会把原始标记原样插进笔记里。
      },

      -- .obsidian/zk-prefixer.json：:Obsidian unique_note 生成时间戳 ID 的笔记。
      -- template 是独立选项，不会回退到 note.template，不设的话 ,oz 建出来是空文件，
      -- 所以这里也显式指到同一份 Jekyll 模板。
      -- 注意：写「Template/ 下的文件名」才和 cwd 无关（resolve_template 会拿
      -- templates.folder 的绝对路径去拼）；写仓库内的其它相对路径会在别的 cwd 下解析失败。
      unique_note = {
        folder = "Zettelkasten",
        format = "YYYYMMDDHHmm",
        template = "Jekyll Template.md",
      },

      -- app.json: attachmentFolderPath=Attachments
      attachments = {
        folder = "Attachments",
      },

      -- 复用已经装好的 telescope
      picker = {
        name = "telescope.nvim",
      },

      -- 渲染交给 plugins/markdown.lua 里的 render-markdown.nvim。
      -- 两边同时开会抢 conceallevel 和 extmark，画面会花。
      ui = { enable = false },

      -- 不自动改写 frontmatter。两个原因：
      -- 1. 仓库里的笔记是 Jekyll 风格 (layout/title/aliases)，默认行为会在每次
      --    保存时补上 id:，Syncthing 那边会多出一堆无意义 diff；
      -- 2. 关掉它，上面 note.template 里的 YAML 才会原样落到新笔记里，
      --    不会被 id/aliases/tags 重写一遍。
      -- 想让它接管 frontmatter 就删掉这一行（但新笔记的模板头会被改写）。
      frontmatter = { enabled = false },

      -- 只在 [ ] 和 [x] 之间切换；默认还会循环 ~ ! > 三种中间态
      checkbox = {
        order = { " ", "x" },
      },

      -- footer 已经取代 statusline，关掉后者免得启动时报废弃警告
      statusline = { enabled = false },
      footer = {
        enabled = true,
        separator = "", -- 默认是 80 个 -，太吵，换成一个空行
      },

      -- wiki 仓库笔记量大，开缓存让搜索和补全快一些
      cache = { enabled = true },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- <C-n> 新建笔记，只在 markdown buffer 里生效（buffer-local），
      -- 不占用 <C-n> 在其它文件类型里的原生行为（普通模式下等价 j，插入模式下是补全）。
      local function bind_new_note(buf)
        vim.keymap.set("n", "<C-n>", "<cmd>Obsidian new<cr>", { buffer = buf, desc = "Obsidian 新建笔记" })
      end

      -- gf 跟随 [[双链]]：原生 gf 依赖 'isfname' 先在光标处圈出一段文件名，
      -- 圈不到就不会去调用下面 bufenter_callback 设的 includeexpr，而默认 isfname
      -- 不含 `[`、`]` 和空格，光标停在方括号或标题里的空格上时原生 gf 直接失效。
      -- 这里绕开 isfname，光标在链接范围内就直接 follow_link，否则落回原生 gf。
      local function bind_gf(buf)
        vim.keymap.set("n", "gf", function()
          if require("obsidian.api").cursor_link() then
            return "<cmd>Obsidian follow_link<cr>"
          end
          return "gf"
        end, { buffer = buf, expr = true, desc = "跟随 [[双链]]（否则原生 gf）" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          bind_new_note(args.buf)
          bind_gf(args.buf)
        end,
      })
      -- ft = "markdown" 触发插件加载时，当前 buffer 的 FileType 事件已经过去，
      -- 上面的 autocmd 补不上，这里手动给当前 buffer 补一次。
      if vim.bo.filetype == "markdown" then
        bind_new_note(0)
        bind_gf(0)
      end
    end,
  },
}

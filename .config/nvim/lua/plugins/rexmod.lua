-- Review comments for your coding agent and the editor side of the Rex Changes panel.
-- Installed by rexmod into ~/Library/Application Support/rexmod/nvim.
return {
  {
    dir = vim.fn.expand("~/Library/Application Support/rexmod/nvim"),
    name = "rexmod.nvim",
    lazy = false,
    config = function()
      require("rexmod").setup()
    end,
  },

  -- Media previews in the editor pane. Rex speaks the kitty graphics protocol, so snacks.image
  -- draws images in Neovim: images and PDFs open as pictures, videos show their first frame
  -- (ffmpeg), and images and mermaid blocks in markdown render beside the text.
  -- `<leader>uo` opens the file in its macOS app, e.g. to play a video.
  {
    "folke/snacks.nvim",
    init = function()
      -- snacks knows kitty, ghostty and wezterm; Rex identifies itself through TERM_PROGRAM.
      -- Unicode placeholders aren't verified in Rex, so images use direct placements.
      local envs = require("snacks.image.terminal").envs()

      -- In rexmod's editor, Neovim runs headless behind the Rex panes and rexmod draws every
      -- window itself. Images go out with nvim_ui_send, which rexmod writes to the panes'
      -- terminals, and they're placed with Unicode placeholders: cells in the grid that move
      -- with the text, into whichever pane shows them. snacks can't ask a headless Neovim's
      -- terminal for its cell size, so rexmod sets g:rexmod_cell.
      if vim.env.REXMOD_MULTIGRID == "1" then
        table.insert(envs, 1, { name = "rex", env = { REXMOD_MULTIGRID = "1" }, supported = true, placeholders = true })
        local terminal = require("snacks.image.terminal")
        local size = terminal.size
        terminal.size = function()
          local s = size()
          local cell = vim.g.rexmod_cell
          if type(cell) == "table" and (cell[1] or 0) > 0 and (cell[2] or 0) > 0 then
            s.cell_width, s.cell_height = cell[1], cell[2]
            s.width, s.height = s.columns * cell[1], s.rows * cell[2]
            s.scale = cell[1] / 8
          end
          return s
        end
        return
      end

      table.insert(envs, 1, { name = "rex", env = { TERM_PROGRAM = "rex" }, supported = true, placeholders = false })

      -- Neovim 0.12 runs the TUI and the editor as two processes, and snacks sends images with
      -- nvim_ui_send, which doesn't reach Rex. In Rex, write them to the TUI's terminal instead:
      -- the parent process's tty.
      if vim.env.TERM_PROGRAM == "rex" then
        local tty
        local function open_tty()
          if tty == nil then
            local name = vim.trim(vim.fn.system({ "ps", "-o", "tty=", "-p", tostring(vim.uv.os_getppid()) }))
            tty = (vim.v.shell_error == 0 and name ~= "" and name ~= "??") and io.open("/dev/" .. name, "w") or false
          end
          return tty
        end
        local terminal = require("snacks.image.terminal")
        local write = terminal.write
        terminal.write = function(data)
          local f = open_tty()
          if not f then
            return write(data)
          end
          data = terminal.transform and terminal.transform(data) or data
          f:write(data)
          f:flush()
        end

        -- Without placeholders an image is a direct placement, and snacks only marks it hidden
        -- when its buffer leaves the window: it stays on screen over the next buffer. Delete
        -- the placement when it hides; snacks places it again when the buffer comes back.
        local placement = require("snacks.image.placement")
        local hide = placement.hide
        placement.hide = function(self)
          -- snacks never clears `hidden` when the image shows again, so don't check it;
          -- hide only runs when the window state changed, and a second delete is harmless.
          if self:ready() then
            terminal.request({ a = "d", d = "i", i = self.img.id, p = self.id })
          end
          return hide(self)
        end
      end
    end,
    opts = {
      image = {
        enabled = true,
        doc = { enabled = true, inline = false, float = true, max_width = 80, max_height = 30 },
      },
    },
    keys = {
      {
        "<leader>uo",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if file ~= "" then
            vim.ui.open(file)
          end
        end,
        desc = "Open File in System App",
      },
    },
  },

  -- Tabs without the separators between them or the bar left of the current one.
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.separator_style = { "", "" }
      opts.options.indicator = { style = "none" }
    end,
  },

  -- In rexmod's editor every window is its own Rex pane, showing its own statusline. lualine
  -- writes its line into whichever window has focus, and Neovim draws a statusline under any
  -- float given one: a picker's input showed it. Floats other than our panes don't get it,
  -- and the global statusline (laststatus=3) stays off.
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function()
      if vim.env.REXMOD_MULTIGRID ~= "1" then
        return
      end
      local nvim_opts = require("lualine.utils.nvim_opts")
      local set = nvim_opts.set
      nvim_opts.set = function(name, val, o)
        -- a global statusline is drawn where no pane shows it
        if name == "laststatus" and val == 3 then
          val = 2
        end
        local win = o and o.window
        if name == "statusline" and win and vim.api.nvim_win_is_valid(win) then
          local c = vim.api.nvim_win_get_config(win)
          if c.relative ~= "" and not c.external then
            return
          end
        end
        return set(name, val, o)
      end
    end,
  },

  -- On the command line the arrows move through the completion menu while it's open, and
  -- through history (Up/Down) or the line (Left/Right) otherwise. LazyVim leaves only Tab.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.cmdline = opts.cmdline or {}
      opts.cmdline.keymap = vim.tbl_extend("force", opts.cmdline.keymap or {}, {
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
      })
    end,
  },

  -- Markdown renders in the buffer: headings, lists, tables, code blocks.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
  },

  -- `<leader>cp` toggles a live preview of the markdown file in the browser.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}

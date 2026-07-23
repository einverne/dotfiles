-- lua/plugins/im-select.lua
-- 输入法自动切换：离开插入模式时切回英文，回到插入模式时恢复之前的输入法。
-- 避免在普通/命令模式下误输中文。macOS 依赖 `macism` 命令行工具 (见 Brewfile-essentials)。
return {
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    opts = {
      -- 普通模式下使用的英文输入源 (macOS 默认 ABC 键盘布局)
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
      -- 这些事件触发切回英文
      set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
      -- 这些事件恢复上次的输入法
      set_previous_events = { "InsertEnter" },
      -- 没装 macism 时保持安静，不弹错误
      keep_quiet_on_no_binary = true,
      async_switch_im = true,
    },
  },
}

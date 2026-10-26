tap "buo/cask-upgrade"

# primitives
brew "axel"
# https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands
brew "coreutils"
brew "exa"
brew "git"
brew "neovim"
# nvim-treesitter main 分支用 tree-sitter CLI 编译 parser，缺失会导致启动报 ENOENT
brew "tree-sitter-cli"
brew "zsh"
brew "zsh-completions"
brew "tmux"
brew "gnupg"
brew "gnu-sed"
# https://github.com/junegunn/fzf
brew "fzf"
# https://github.com/ggreer/the_silver_searcher
brew "the_silver_searcher"
brew "hub"
brew "tmux"
brew "trash"
brew "tree"
brew "wget"
brew "rsync"

# tools
brew "ipinfo-cli"
brew "youtube-dl"
brew "ffmpeg"
brew "imagemagick"
brew "mas"
brew "nmap"
brew "p7zip"
brew "dos2unix"
brew "proxychains-ng"
brew "htop"
brew "neofetch"
brew "readline"
brew "cmake"
brew "sqlite"
brew "xz"
brew "zlib"

# productivity
brew "ripgrep"
brew "fd"
brew "pngpaste"      # nvim obsidian.nvim 粘贴剪贴板图片 (:Obsidian paste_img)
# brew "hexyl"
# brew "xsv"
brew "jq"
# brew "hledger"

# dev
brew "mise"          # 运行时版本管理器 (Python/Node/Flutter 等)
# brew "ruby"
# brew "go"
# brew "postgresql"
# brew "heroku"
# brew "node"
# brew "yarn"
# brew "wrk"

# skip GUI apps in CI; brew only passes CI (not CI_MODE) through to Brewfile
unless ENV.key? 'CI'
cask "appcleaner"
cask "font-fira-code"
cask "font-fira-code-nerd-font"
cask "google-chrome"
cask "hammerspoon"
cask "iina"
cask "iterm2"
cask "karabiner-elements"
cask "keycastr"
cask "mos"
cask "nextcloud"
cask "visual-studio-code"
cask "syncthing"
cask "neteasemusic"
# open broadcaster software
cask "obs"
# note-taking app
cask "obsidian"
# cask "dropbox"
cask "postman"
# cask "qmk-toolbox"
cask "upic"
cask "musicbrainz-picard"

mas "WeChat", id: 836500024
mas "Unsplash Wallpapers", id: 1284863847
mas "Microsoft OneNote", id: 784801555
# mas "Lungo", id: 1263070803
mas "Pages", id: 409201541
mas "Numbers", id: 409203825
mas "Keynote", id: 409183694
end

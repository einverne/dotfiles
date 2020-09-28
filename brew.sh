# https://github.com/mathiasbynens/dotfiles/blob/main/brew.sh
brew update
brew upgrade

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
# GNU multiple precision arithmetic library
brew install gmp

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

brew install ack
brew install git-lfs
brew install imagemagick --with-webp
brew install p7zip

# Remove outdated versions from the cellar.
brew cleanup

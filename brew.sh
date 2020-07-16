# https://github.com/mathiasbynens/dotfiles/blob/main/brew.sh
brew update
brew upgrade

# https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget --with-iri
# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
# GNU multiple precision arithmetic library
brew install gmp

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

brew install ack
brew install git
brew install git-lfs 
brew install imagemagick --with-webp
brew install p7zip
brew install ssh-copy-id
brew install tree

# Remove outdated versions from the cellar.
brew cleanup

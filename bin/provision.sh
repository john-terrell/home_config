# Debian/Ubuntu Linux provision script
# Note: this gist is attached to a shortened URL:  http://bit.do/jterrell_config
# execute with curl -sL http://bit.do/jterrell_config | bash
set -e

sudo apt-get -y install zsh
sudo apt-get -y install git
sudo apt-get -y install curl wget

# Pyenv dependencies
sudo apt-get -y install zlib1g-dev
sudo apt-get -y install libbz2-dev
sudo apt-get -y install libreadline-dev
sudo apt-get -y install libssl-dev
sudo apt-get -y install libsqlite3-dev
sudo apt-get -y install make
sudo apt-get -y install build-essential 
sudo apt-get -y install libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Dev dependencies
sudo apt-get -y install clang

sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

# OpenGL dependencies
sudo apt-get -y install mesa-common-dev

# OSG dependencies
sudo apt-get -y install ffmpeg libtiff5-dev

# osgEarth dependencies
sudo apt-get -y install gdal-bin libgdal-dev libglew-dev libzip-dev librocksdb-dev protobuf-compiler


sudo chsh --shell /usr/bin/zsh $USER

# Setup local .cfg repository to put parts of $HOME under version control
# from: https://www.atlassian.com/git/tutorials/dotfiles
if [ ! -d $HOME/.cfg ]; then
   git clone --bare https://github.com/john-terrell/home_config.git $HOME/.cfg
fi

if [ ! -d $HOME/.pyenv ]; then
  git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
fi

function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

# Make sure Powerlevel10K is installed
if [ ! -d $HOME/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
else
  git -C $HOME/powerlevel10k pull
fi

# Make sure rustup is run
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Make sure the font cache is updated since .fonts contains the fonts we want.
fc-cache -f -v

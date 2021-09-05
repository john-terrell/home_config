# Debian/Ubuntu Linux provision script
# Note: this gist is attached to a shortened URL:  http://bit.do/jterrell_config
# execute with curl -sL http://bit.do/jterrell_config | bash
sudo apt-get -y install zsh
sudo apt-get -y install git
sudo apt-get -y install curl

# Setup local .cfg repository to put parts of $HOME under version control
# from: https://www.atlassian.com/git/tutorials/dotfiles
if [ ! -d $HOME/.cfg ]; then
   git clone --bare https://github.com/john-terrell/home_config.git $HOME/.cfg
else
   git pull -C $HOME/.cfg
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


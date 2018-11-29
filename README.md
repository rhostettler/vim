# vim
Vim config.

## Bootstrapping
Clone into `.vim` directory and link `vimrc`:

    cd
    git clone git@github.com:rhostettler/vim.git .vim
    ln -s .vim/vimrc .vimrc

Install Vundle and install plugins:

    cd .vim
    git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
    vim +PluginInstall +qall


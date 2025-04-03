# Dotfiles Management

## Add a File or Folder

```bash
dotfiles add .config/nvim/
dotfiles commit -m "add neovim dotfiles to track"
dotfiles push
```


## Commit and Push Changes

```bash
dotsync "optional commit msg"
```

## On a New Machine

```bash
git clone --bare git@github.com:ewencb/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
```

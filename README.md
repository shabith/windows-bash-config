Git Bash Config
====================

A repo-centric bash config designed for [Git BASH](https://git-for-windows.github.io/) - git for windows

Features
========

#### 1. Functions - `.functions`
| Function name | Description  | How to use |
| --- |---|---|
| `gig` |  use [gitignore.io]() to generate gitignore file and copy that to clipboard | eg: `gig windows,visualStudioCode,node` |
| `gh` | open gihub page of the repo | `gh` |
| `clone` | based on [@stephenplusplus  dotfile](https://github.com/stephenplusplus/dots/blob/master/.bash_profile) by @stephenplusplus <br /><br /> **arg 1** - url &#124; username &#124; repo remote endpoint, username on github, or name of repository. <br /><br />**arg 2** - (`optional`) name of repo | eg1: `clone window-bash-config` <br /> <br /> eg2: `clone yeoman generator`<br /><br /> eg3: `clone git@github.com:addyosmani/dotfiles.git`|
| `glr` | simple git log | `glr` |
| `f` | find shorthand<br /><br />**arg1** - filename | eg: `f README.md` |
| `gitexport` | take this repo and copy it to somewhere else minus the .git stuff.<br /><br /> **arg1** - path to export | eg: `gitexport '~/static/'` |
| `mkd` | Create a new directory and enter it | eg: `mkd hello-world` |
| `fs` | # Determine size of a file or total size of a directory | eg: `fs` |
| `gitio` | Create a git.io short URL<br /><br > **arg1** - code to setup your own vanity URL <br /><br /> **arg2** - github URL | eg: `gitio shabi http://github.com/shabith` |
| `o` | with no arguments opens the current directory, otherwise opens the given location | eg1: `o` <br /><br /> eg2: `o directory` |
| `v` | with no arguments opens the current directory in Vim, otherwise opens the given location | eg1: `v` <br /><br /> eg2: `v directory` |
| `a` | with no arguments opens the current directory in Atom, otherwise opens the given location | eg1: `a` <br /><br /> eg2: `a directory` |
| `c` | with no arguments opens the current directory in Visual Studio Code, otherwise opens the given location | eg1: `c` <br /><br /> eg2: `c directory` |



Getting Started
===============

  ```
  cd ~
  git clone https://github.com/shabith/windows-bash-config config
  cd config
  . setup

  ```

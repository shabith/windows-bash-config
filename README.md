SkilStak Bash Config
====================

A repo-centric bash config designed mainly for Ubuntu Linux and the
SkilStak Desktop on a Stick ([skilstak.io][]) but others
can maybe find use for it.

While this works on Mac and Windows (if you must) try to use it from
the Linux VM referenced or your own for best use.

Reasoning 
=========

At SkilStak Coding Arts we assume *everything* we use comes from one of
five places:

1. The operating system (think ISOs and VMs)
2. A package manager (think `apt-get` and `dpkg`)
3. A git repo (think, well, `git`)
4. A cloud storage service (think Dropbox or Google Drive)
5. A personal USB drive that has been backed up to a computer.

Anything worth keeping is in one of those places (or should be) and
anything not in one of these four places should be considered
expendable.

This means you lose next to nothing when your machine dies or you forgot
it and have to use another one, (which is frequently required to maintain
sanity in an classroom or working environment).

What does it do?
================

* Builds paths from executables in `~/repos/*` and `~/repos/*/bin`
* Adds a `repo` command with tab completion
* Adds [powergit][] command line aliases and functions
* Adds solarized color palette (yes even to windows) and variables
* Adds `~/vimfiles` and vim-centric aliases
* Adds `ssh` tab-completion based on `.ssh/config` and utils 
* Adds aliases, filters, functions for jekyll blogging (`com`, `me`)
* Adds a `note` command with tab completion
* Uses a `bigprompt` to help beginners feel safer
* Has `medprompt`, `pwdprompt`, and `noprompt` options as well
* Fixes many windows-centricities with `git-bash`

I realize this isn't for everyone. It's rather opinionated and originally
designed to provide a consistent (and yes branded) command-line shell
experience for beginners that just want to get up and running while they
learn to become bash shell commanders later (with their own bashrcs
and such).

SkilStak Ubuntu Desktop/Server on a Stick
=========================================

Another option for beginners (and educators) is to just download the
SkilStak Server or Desktop on a Stick Ubuntu Linux Server images from
[skilstak.io][]. It just needs the free version of VMWare Player to use
and allows a highly-recommended native Linux server experience. 
We've put all the latest tools on it as well to reduce installation
time if you are in class or working on class projects.

Using a VM: 

* Eliminates quirks from different operating system shells
* Allows easy backups of the entire dev env including automation
* Can be downloaded or uploaded from cloud hosting

At a maximum of 2GB RAM, this is particularly useful for emulating
a cloud-hosted development environment all web and mobile app
developers need. Keep in mind only one VMware image per machine is
possible with the free version of vmware player.

This is particularly recommended for those stuck with Windows since no
matter how much you optimize and pretty-up the Windows git-bash
experience the command-line remains insanely slow, choppy, and buggy.

Getting Started
===============

  ```
  cd ~
  git clone https://github.com/skilstak/config
  cd config
  . setup

  ```

You can personalize and extend this by adding a `repos/personal/bashrc`
and/or `repos/private/bashrc`, which is called from the main
`config/bashrc`.

Or you can just fork https://github.com/skilstak/config and maintain
your own pulls once you understand all that entails.

[powergit]: http://github.com/skilstak/powergit
[skilstak.io]: http://skilstak.io

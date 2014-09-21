SkilStak Bash Config
====================

A repo-centric, bash config suitable for linux, bsd, windows
(git-bash) (and eventually smartos/illuminos).

If you are one of our SkilStak Coding Arts team of developers, mentors and
learners you already know what this is. If not, welcome, maybe you'll find
this helpful to get you started on your way to becoming a bash shell
commander.

At SkilStak we assume *everything* we use comes from one of five places:

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
* Adds solarized color palette (to windows) and variables
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

SkilStak Ubuntu Server VMWare Image
===================================

Another option for beginners (and educators) is to just download the
SkilStak Server on a Stick Ubuntu Linux Server image from our public
dropbox, which is linked from [skilstak.io][]. It just needs the free
version of VMWare Player to use and allows a highly-recommended native
Linux server experience. We've put the latest developer Node.js on it as
well.

Server-on-a-stick (or desktop) is increasingly becoming part of the
standard toolset and workflow for developers of all kinds. Coupled
with repo-centric configuration and provisioning this provides what
many consider an ideal modern development environment:

* It eliminates quirks from different operating system shells
* It allows easy backups of the entire dev env including automation
* Environment (images) can be downloaded or uploaded from cloud hosting

At a maximum of 2GB RAM, this is particularly useful for emulating
a cloud-hosted development environment all web and mobile app
developers need. Keep in mind only one vmware image per machine is
possible with the free version of vmware player.

This is particularly recommended for those stuck with Windows since no
matter how much you optimize and pretty-up the Windows git-bash
experience the command-line remains insanely slow, choppy, and buggy.
@SkilStak we've decided to use the Linux images combined with this
`conifg` pulled down onto Windows machines with `git-bash` installed
and then `ssh` into the image on the same machine since that workflow
exactly models a modern professional development environment.

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

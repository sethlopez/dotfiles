# dotfiles

My personal dotfiles and setup scripts for setting up new environments.

## Getting Started

Getting up and running with these dotfiles should be relatively easy and only
involves a few steps.

### 1. Download

To download the dotfiles, run the following command:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sethlopez/dotfiles/HEAD/download.sh)"
```

### 2. Set up environment

As I have thus far worked exclusively on macOS, I currently only have a macOS
setup script. This section may be expanded later to include other environments.

#### macOS

To setup a macOS environment, run the following command:

```sh
$HOME/dotfiles/dot macos-setup
```

### 3. Install

To install the dotfiles, run the following command:

```sh
$HOME/dotfiles/dot install
```

### 4. Link the `dot` command

To put `dot` on the `PATH`, symlink it into `$HOME/bin`:

```sh
ln -s "$HOME/dotfiles/dot" "$HOME/bin/dot"
```

## Managing dotfiles

A `dot` command on the `PATH` manages the dotfiles. It can always be run from
`$HOME/dotfiles/dot` instead.

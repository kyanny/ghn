# Ghn

[![Build Status](https://travis-ci.org/kyanny/ghn.png?branch=master)](https://travis-ci.org/kyanny/ghn)

List/Open unread GitHub Notifications.

## Installation

```
$ gem install ghn
```

## Usage

```
$ ghn help
Commands:
  ghn help [COMMAND]  # Describe available commands or one specific command
  ghn list NAME       # List unread notifications
  ghn open NAME       # Open unread notifications in browser

Options:
  -a, [--all], [--no-all]  # List/Open all unread notifications
```

NAME should be a username/reponame of repository.

`$ ghn list` displays first 50 unread notifications to STDOUT.

`$ ghn open rails/rails` opens first 50 unread notifications of rails/rails in your browser.

`$ ghn open -a` opens all unread notifications in your browser.

## Aliases

You can set aliases as a shortcut of NAME.
Aliases should be stored to your global `.gitconfig` file.

`$ git config --global ghn.alias.play playframework/playframework`

Now `$ ghn open play` opens unread notifications of playframework/playframework in your browser.

NOTE: aliases must have **ghn.alias** namespace.

## Authentication

Please set **ghn.token** to your `.gitconfig`.

    $ git config --global ghn.token [Your GitHub access token]

You can also set access token via `GHN_ACCESS_TOKEN` environment variable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

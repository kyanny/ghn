# Ghn

Commandline tool for GitHub notifications.

## Installation

    $ gem install ghn

## Usage

Run `ghn list` to show all unread notifications in terminal.

`ghn list` takes argument `user/repo` to get notifications only target repository.

If you give `--open` option, unread notifications are opened in your default browser.

If you give `--mark-as-read` option, notifications are marked as read.

You can see usage by `-h`, `--help` or `--usage` option.

## Authentication

Please set ghn.token to your .gitconfig.

    $ git config --global ghn.token [Your GitHub access token]

You can also set access token via ACCESS_TOKEN environment variable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

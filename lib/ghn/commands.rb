class Ghn
  class Commands < Thor
    class_option :all, type: :boolean, aliases: '-a', desc: 'List/Open all unread notifications'

    desc 'list NAME', 'List unread notifications'
    def list(name = nil)
      repo_full_name = aliases.find(name) || name
      puts collect(repo_full_name)
    end

    desc 'open NAME', 'Open unread notifications in browser'
    def open(name = nil)
      repo_full_name = aliases.find(name) || name
      collect(repo_full_name).each do |url|
        system "#{open_command} #{url}"
      end
    end

    private

    def collect(repo_full_name = nil)
      threads = []
      collector = Collector.new(client, repo_full_name)
      # Unfortunately, GitHub v3 Notifications API doesn't accept octokit's auto_paginate option
      # because this API doesn't return Link header so far.
      loop.with_index(1) do |_, page|
        threads += collector.collect(page)
        break unless options['all']
        break unless collector.has_next?
      end

      threads
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def aliases
      @aliases ||= Aliases.new
    end

    def access_token
      @access_token ||=
        case
        when ENV['GHN_ACCESS_TOKEN']
          ENV['GHN_ACCESS_TOKEN']
        when !`git config ghn.token`.chomp.empty?
          `git config ghn.token`.chomp
        else
          puts <<MESSAGE
** Authorization required.

Please set ghn.token to your .gitconfig.
    $ git config --global ghn.token [Your GitHub access token]

To get new token, visit
https://github.com/settings/tokens/new

MESSAGE
          exit!
        end
    end

    def open_command
      @open_command ||=
        case RbConfig::CONFIG['host_os']
        when /darwin/
          'open'
        when /linux|bsd/
          'xdg-open'
        when /mswin|mingw|cygwin/
          'start'
        end
    end
  end
end

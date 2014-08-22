class Ghn
  class Commands < Thor
    class_option :all, type: :boolean, aliases: '-a', desc: 'Process all unread notifications (without pagination)'

    desc 'list REPO_FULL_NAME', 'List all unread notifications'
    def list(repo_full_name = nil)
      puts collect(repo_full_name)
    end

    desc 'open REPO_FULL_NAME', 'Open all unread notifications in browser'
    def open(repo_full_name = nil)
      collect(repo_full_name).each do |url|
        system "open #{url}"
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
  end
end

class Ghn
  class Commands < Thor
    class_option :all, type: :boolean, aliases: '-a', desc: 'List/Open all unread notifications'
    class_option :participating, type: :boolean, aliases: '-p', desc: 'List/Open notifications your are participating'
    class_option :follow_issuecomment, type: :boolean, desc: 'Follow issuecomment anchor URL'
    class_option :sort, type: :boolean, aliases: '-s', desc: 'Sort notifications by URL'
    class_option :verbose, type: :boolean, aliases: '-v', desc: 'Verbose message'

    desc 'list NAME', 'List unread notifications'
    def list(name = nil)
      repo_full_name = aliases.find(name) || name
      puts collect(repo_full_name)
    end

    desc 'open NAME', 'Open unread notifications in browser'
    def open(name = nil)
      repo_full_name = aliases.find(name) || name
      collect(repo_full_name).each do |url|
        puts "Opening.. #{url}" if options["verbose"]
        system "#{open_command} #{url}"
        sleep 0.5 # prevent `LSOpenURLsWithRole() failed with error` on Mac OSX Yosemite
      end
    end

    private

    def collect(repo_full_name = nil)
      threads = []
      collector = Collector.new(client, repo_full_name, follow_issuecomment: follow_issuecomment?, participating: options['participating'])
      # Unfortunately, GitHub v3 Notifications API doesn't accept octokit's auto_paginate option
      # because this API doesn't return Link header so far.
      loop.with_index(1) do |_, page|
        threads += collector.collect(page)
        break unless options['all']
        break unless collector.has_next?
      end

      if options['sort']
        regexp = /^(.*\/)([0-9]+)/
        threads.sort! do |a, b|
          _, repo_a, number_a = regexp.match(a).to_a
          _, repo_b, number_b = regexp.match(b).to_a
          (repo_a <=> repo_b).nonzero? || (number_a.to_i <=> number_b.to_i)
        end
      end
      threads
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def aliases
      @aliases ||= Aliases.new
    end

    def follow_issuecomment?
      val = (options['follow_issuecomment'] || `git config ghn.followissuecomment`.chomp).to_s
      if val.empty?
        false
      elsif val.match(/off|no|false/i)
        false
      else
        true
      end
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
          'open --background'
        when /linux|bsd/
          'xdg-open'
        when /mswin|mingw|cygwin/
          'start'
        end
    end
  end
end

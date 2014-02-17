require 'ghn/version'
require 'ghn/token'
require 'ghn/options'
require 'ghn/command'
require 'github_api'

class Ghn
  def initialize(token, command, options)
    @token = token
    @command = command
    @options = options
  end

  def run
    send(@command.command, *@command.args)
  end

  def run_print
    run.each do |notification|
      if @options.open_browser?
        system "open #{notification}"
      else
        puts notification
      end
    end
  end

  def client
    @client ||= Github.new(oauth_token: @token.token)
  end

  def list(target = nil)
    params = {}
    unless target.nil?
      params['user'], params['repo'] = target.split('/')
    end

    client.activity.notifications.list(params).map { |notification|
      repo = notification.repository.full_name
      type = notification_type(notification.subject.url)
      number = notification.subject.url.match(/[^\/]+\z/).to_a.first
      if @options.mark_as_read?
        self.mark(notification.id)
        "[x] https://github.com/#{repo}/#{type}/#{number}"
      else
        "https://github.com/#{repo}/#{type}/#{number}"
      end
    }
  end

  def mark(id, read = true)
    client.activity.notifications.mark(thread_id: id, read: read)
  end

  private
  def notification_type(url)
    case url
    when /pulls/
      'pull'
    when /issues/
      'issues'
    else
      'commit'
    end
  end
end

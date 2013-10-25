require 'ghn/version'
require 'ghn/options'
require 'ghn/command'
require 'github_api'

class Ghn
  attr_accessor :open_browser, :mark_as_read
  alias_method :open_browser?, :open_browser
  alias_method :mark_as_read?, :mark_as_read

  def initialize(access_token)
    @access_token = access_token
  end

  def client
    @client ||= Github.new(oauth_token: @access_token)
  end

  def list(target = nil)
    params = {}
    unless target.nil?
      params['user'], params['repo'] = target.split('/')
    end

    client.activity.notifications.list(params).map { |notification|
      repo = notification.repository.full_name
      type, number = if notification.subject.url.match(/pulls/)
                       ['pull', notification.subject.url.match(/[^\/]+\z/).to_a.first]
                     else
                       ['issues', notification.subject.url.match(/[^\/]+\z/).to_a.first]
                     end
      if mark_as_read?
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
end

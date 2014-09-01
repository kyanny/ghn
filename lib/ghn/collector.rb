class Ghn
  class Collector
    attr_reader :client, :repo_full_name, :follow_issuecomment

    def initialize(client, repo_full_name = nil, follow_issuecomment = false)
      @client = client
      @repo_full_name = repo_full_name
      @follow_issuecomment = follow_issuecomment
    end

    def collect(page = 1)
      notifications = if repo_full_name
                        client.repo_notifications(repo_full_name, page: page)
                      else
                        client.notifications(page: page)
                      end
      @count = notifications.count
      notifications.map { |notification|
        Notification.new(notification, follow_issuecomment).type_class.new(notification, follow_issuecomment).url
      }.compact
    end

    def has_next?
      @count == 50
    end
  end
end

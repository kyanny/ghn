class Ghn
  class Collector
    attr_reader :client, :repo_full_name, :follow_issuecomment, :participating

    def initialize(client, repo_full_name = nil, options = {})
      @client = client
      @repo_full_name = repo_full_name
      @follow_issuecomment = options[:follow_issuecomment] || false
      @participating = options[:participating] || false
    end

    def collect(page = 1)
      notifications = if repo_full_name
                        client.repo_notifications(repo_full_name, page: page, participating: participating)
                      else
                        client.notifications(page: page, participating: participating)
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

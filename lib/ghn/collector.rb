class Ghn
  class Collector
    def initialize(client, repo_full_name = nil)
      @client = client
      @repo_full_name = repo_full_name
    end

    def collect(page = 1)
      notifications = if @repo_full_name
                        @client.repo_notifications(@repo_full_name, page: page)
                      else
                        @client.notifications(page: page)
                      end
      @count = notifications.count
      notifications.map { |notification|
        Notification.new(notification).type_class.new(notification).url
      }.compact
    end

    def has_next?
      @count == 50
    end
  end
end

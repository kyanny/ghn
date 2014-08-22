class Ghn
  class Notification
    attr_reader :notification

    def initialize(notification)
      @notification = notification
    end

    def to_url
      if comment?
        "https://github.com/#{repo_full_name}/#{type}/#{thread_number}#issuecomment-#{comment_number}"
      else
        "https://github.com/#{repo_full_name}/#{type}/#{thread_number}"
      end
    end

    private

    def comment?
      notification[:subject][:url] != notification[:subject][:latest_comment_url]
    end

    def repo_full_name
      notification[:repository][:full_name]
    end

    # https://github.com/quipper/qlink/commit/6a4a135335acef4dfe15912d231429c07d4ad143
    def type
      case notification[:subject][:type]
      when 'Issue'
        'issues'
      when 'PullRequest'
        'pull'
      when 'Commit'
        'commit'
      else
        raise RuntimeError, "unknown subject type #{notification[:subject][:type]}"
      end
    end

    def thread_number
      notification[:subject][:url].match(/[^\/]+\z/)[-1]
    end

    def comment_number
      if comment?
        notification[:subject][:latest_comment_url].match(/\d+\z/)[-1]
      end
    end
  end
end

require 'hashie/mash'

class Ghn
  class Options < Hashie::Mash
    def open_browser=(bool)
      @open_browser = bool
    end

    def open_browser?
      !!(@open_browser || self['o'] || self['open'])
    end

    def mark_as_read=(bool)
      @mark_as_read = bool
    end

    def mark_as_read?
      !!(@mark_as_read || self['m'] || self['mark-as-read'])
    end

    def help?
      !!(self['h'] || self['help'])
    end

    class << self
      def short_options
        'omh'
      end

      def long_options
        ['open', 'mark-as-read', 'help', 'usage']
      end

      def usage
        <<-USAGE
Usage: #{File.basename $0} [options] [command] [user/repo]
    options:   -o, --open           Open notifications in browser
               -m, --mark-as-read   Mark as read listed notifications
               -h, --help, --usage  Show this message

    command:   list             List unread notifications

    user/repo: GitHub user and repository (e.g. github/hubot)
               You can specify it to narrow down target notifications

        USAGE
      end

      def print_usage
        puts usage
      end

      def print_usage_exit
        print_usage
        exit
      end
    end
  end
end

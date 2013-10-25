class Ghn
  class Token
    attr_reader :token

    def initialize
      @valid = false
      process!
    end

    def process!
      @token = ENV['ACCESS_TOKEN'] || `git config ghn.token`.chomp

      if @token.nil? || @token.empty?
        @valid = false
      else
        @valid = true
      end
    end

    def valid?
      !!@valid
    end

    def print_no_access_token
      puts <<MESSAGE
** Authorization required.

Please set ghn.token to your .gitconfig.
    $ git config --global ghn.token [Your GitHub access token]

MESSAGE
    end

    def print_no_access_token_exit!
      print_no_access_token
      exit!
    end
  end
end

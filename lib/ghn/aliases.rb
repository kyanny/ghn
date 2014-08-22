class Ghn
  class Aliases
    def initialize
      @aliases = {}

      `git config --get-regexp ghn.alias`.each_line.each do |line|
        line.chomp!
        alias_name, repo_full_name = line.split(/\s+/)
        alias_name = alias_name.split('.')[-1]
        @aliases[alias_name] = repo_full_name
      end
    end

    def find(alias_name)
      @aliases[alias_name]
    end
  end
end

#require 'byebug'

require_relative 'contact'
require_relative 'command'
require_relative 'list_command'
require_relative 'new_command'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.

end

class Cli

  def initialize()
    @commands = {
      list: List.new,
      new: New.new
    }
  end

  def run(args)
    case args.length
      when 0
        main_menu
      else
#        byebug
        puts args[0].to_sym
        return @commands[args[0].to_sym].run(args) if @commands.has_key? args[0].to_sym
        undefined args
    end
    puts "test"
  end

  def main_menu()
    puts "Available commands"
    @commands.values.each do |cmd|
      puts "  #{cmd.name}  -  #{cmd.help}"
    end
  end

  def undefined(args)

  end

  class << self

    def get_s(regex = /.*/)
      input = STDIN.gets.chomp.strip
      return input if input.match(regex)
      nil
    end
  end

end

Cli.new.run(ARGV)

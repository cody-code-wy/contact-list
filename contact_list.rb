#!/usr/bin/env ruby

require_relative 'contact'
require_relative 'command'
require_relative 'list_command'
require_relative 'new_command'
require_relative 'show_command'
require_relative 'search_command'
require_relative 'contact_formatter'
require_relative 'phone_number'
# Interfaces between a user and their contact list. Reads from and writes to standard I/O.

class Cli

  def initialize()
    @commands = {
      list: List.new,
      new: New.new,
      show: Show.new,
      search: Search.new
    }
  end

  def run(args)
    if args.count == 0
      main_menu
    else
      if @commands.has_key? args[0].to_sym
        command = @commands[args[0].to_sym]
        cargs = command.prompts ? get_args(command) : args
        puts command.run(cargs)
      else
        undefined args
      end
    end
  end

  def get_args(command)
    args = {}
    command.prompts.each do |key, value|
      next unless key.is_a? String
      arry = []
      if value[1] == :Any
        puts "Press enter on empty line to contine."
        puts "Please enter all #{key.to_s}"
        while true do
          input = get_input(command, key.to_s, value, true)
          break unless input
          arry << input
        end
      else
        value[1].times do |num|
          arry << get_input(command, "#{key.to_s} #{num}", value)
        end
      end
      args[key] = arry
    end
    args
  end

  def get_input(command, name, args, return_false=false)
    while true do
      print "#{name} "
      print command.prompts[:prompt]
      raw = command.prompts[:from].gets
      raw = command.prompts[:chomp] ? raw.chomp : raw
      raw = command.prompts[:strip] ? raw.strip : raw
      return false if raw.empty? && return_false
      break if args[2] == :Any || raw.length == args[2]
      puts "\nYou must input exactly #{args[2]} characters!"
    end
    input = case args[0]
            when :String
              raw.to_s
            when :Int
              raw.to_i
            when :Sym
              raw.to_sym
            when :Float
              raw.to_f
            when :Decimal
              raw.to_d
            else
              raise ArugmentError, "Cannot convert to unknow type '#{value[0]}'"
            end
    input
  end

  def main_menu()
    puts "Available commands"
    @commands.values.each do |cmd|
      puts "  #{cmd.name}  -  #{cmd.help}"
    end
  end

  def undefined(args)
    puts "Sorry, i could not understand `#{args.join(" ")}`"
  end

  class << self

    def get_s(regex = /.*/)
      input = STDIN.gets.chomp.strip
      return input if input.match(regex)
      nil
    end
  end

end

Cli.new.run(ARGV) if $0 == __FILE__

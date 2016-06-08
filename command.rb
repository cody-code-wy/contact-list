class Command

  attr_reader :help
  attr_reader :name
  attr_reader :prompts

  def initialize
    @help = "This command has no help"
    @name = "Unnamed Command"
    @prompts = nil
  end

  def run(_)
    puts "This command is not fully implemented, please update your application and try again"
  end

end

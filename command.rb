class Command

  attr_reader :help
  attr_reader :name

  def initialize
    @help = "This command has no help"
    @name = "Unnamed Command"
  end

  def run
    puts "This command is not fully implemented, please update your application and try again"
  end

end

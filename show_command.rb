class Show < Command
  
  def initialize
    @help = "Shows the contact with the given id"
    @name = "Show"
  end

  def run(args)
    if args[1] && args[1].match(/^\d+$/)
      return Contact.find(args[1].to_i)
    else
      return "You must provide a number\nfor example `show 1`"
    end
  end
end

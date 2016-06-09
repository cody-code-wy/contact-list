class Destroy < Command

  def initialize
    super
    @help = "Destroys the contact with the given id"
    @name = "Show"
  end

  def run(args)
    if args[1] && args[1].match(/^\d+$/)
      "Destroyed\n #{ContactFormatter.new(Contact.find(args[1].to_i).destroy).long_format}"
    else
      "You must provide a number\nfor example `show 1`"
    end
  end
end

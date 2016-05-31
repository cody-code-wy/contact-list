class Search < Command

  def initialize
    super
    @help = "Search over entire contact list"
    @name = "search"
  end

  def run(args)
    if args[1]
      Contact.search(args[1].downcase)
    else
      return "You must specify a search criteria\nFor example `search bob'"
    end
  end
end

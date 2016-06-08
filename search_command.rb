class Search < Command

  def initialize
    super
    @help = "Search over entire contact list"
    @name = "search"
  end

  def run(args)
    if args[1]
      contacts = Contact.search(args[1].downcase)
      out = ''
      contacts.each do |contact|
        out << "#{ContactFormatter.new(contact).long_format}\n"
      end
      out
    else
      return "You must specify a search criteria\nFor example `search bob'"
    end
  end
end

class List < Command

  def initialize
    super
    @name = "List"
    @help = "Lists all contacts"
  end

  def run(_)
    out = ""
    contacts = Contact.all
    contacts.each do |contact|
      formatter = ContactFormatter.new(contact)
      out << "#{formatter.short_format}\n"
    end
    out
  end
end

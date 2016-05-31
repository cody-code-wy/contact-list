class List < Command

  def initialize
    @name = "List"
    @help = "Lists all contacts"
  end

  def run(_)
    out = ""
    contacts = Contact.all
    contacts.each do |contact|
      out << "ID:#{contact.id}\n  #{contact.firstname} #{contact.lastname}"
      out << "\n"
    end
  end
end

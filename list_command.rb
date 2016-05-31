class List < Command

  def initialize
    @name = "List"
    @help = "Lists all contacts"
  end

  def run
    contacts = Contact.all
    contacts.each do |contact|
      puts "ID:#{contact.id}\n  #{contact.firstname} #{contact.lastname}"
    end
  end
end

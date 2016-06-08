class ContactFormatter

  def initialize(contact)
    @contact = contact
  end

  def short_format()
    return "No Contact" unless @contact
    "ID:#{@contact.id}\n   #{@contact.first_name} #{@contact.last_name}"
  end

  def long_format()
    return "No Contact" unless @contact
    phone_numbers = @contact.phone_numbers.reduce("") { |out,number| out << "\n      #{number.phone_number}" }
    "Contact ##{@contact.id}\n   #{@contact.first_name} #{@contact.last_name}\n    Email: #{@contact.email}\n      Phone Numbers#{phone_numbers}"
  end
end

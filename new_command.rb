class New < Command

  def initialize
    super
    @help = "Create new contact"
    @name = "New"
    @prompts = {
      "First Name: " => [:String,1,:Any],
      "Last Name: " => [:String,1,:Any],
      "Email Address: " => [:String,1,:Any],
      "Phone Numbers" => [:String,:Any,10],
      prompt: "> ",
      from: STDIN,
      chomp: true,
      strip: true
    }
  end

  def run(args)
    contact = Contact.new(args['First Name: '][0],args['Last Name: '][0],args['Email Address: '][0]).update
    phone_numbers = args['Phone Numbers'].map do |number|
      PhoneNumber.new(number, contact.id)
    end
    phone_numbers.each { |number| contact.add_phone_number number }
    contact.update
  end

end

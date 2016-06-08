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
    puts "Adding #{firstname} #{lastname}..."
    Contact.new(args['First Name: '][0],args['Last Name: '][0],args['Email Address: '][0],args['Phone Numbers']).update
  end

end

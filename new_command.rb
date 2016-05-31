class New < Command

  def initialize
    super
    @help = "Create new contact"
    @name = "New"
  end

  def run(_)
    print "First Name: "
    firstname = Cli.get_s
    print "Last Name: "
    lastname = Cli.get_s
    print "Email Address: "
    email = Cli.get_s
    print "Phone Number: "
    phonenumber = Cli.get_s(/\d{10}/)
    until phonenumber
      puts "please enter the phone number with no speprators"
      puts "like `1234567890`. It must also be 10 digits long!"
      print "Phone Number: "
      phonenumber = Cli.get_s(/\d{10}/)
    end
    puts "Adding #{firstname} #{lastname}..."
    Contact.create(firstname,lastname,email,phonenumber)
  end

end

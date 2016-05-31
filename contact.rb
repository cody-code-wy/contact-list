require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :firstname, :lastname, :email, :phonenumber, :id

  # @param firstname [String] The contact's first name
  # @param lastname [String] The contact's last name
  # @param email [String] The contact's email address
  # @param phonenumber [String] The contact's phone number
  # @param id [Fixnum] The contact's id number
  def initialize(firstname, lastname, email, phonenumber, id)
    @firstname = firstname
    @lastname = lastname
    @email = email
    @phonenumber = phonenumber
    @id = id
  end

  def to_s
    "Contact ID:#{id}\n  #{firstname} #{lastname}\n    #{email}\n    #{phonenumber.gsub(/(\d{3})(\d{3})(\d{4})/,'\1-\2-\3')}"
  end

  def to_a
    [firstname,lastname,email,phonenumber,id]
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      CSV.foreach("contacts.csv") do |contact|
        contacts << Contact.new(contact[0],contact[1],contact[2],contact[3],contact[4].to_i)
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    def create(firstname,lastname,email,phonenumber)
      contacts = all
      next_id = contacts.reduce(0) do |id,contact|
        id = contact.id + 1 if contact.id >= id
        id
      end
      contacts << Contact.new(firstname,lastname,email,phonenumber,next_id)
      CSV.open("contacts.csv", 'w') do |csv|
        contacts.each { |to_add| csv << to_add.to_a }
      end
      contacts.last
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      contacts = all
      contacts.detect do |contact|
        contact.id == id
      end
    end

    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contacts = all
      contacts.select do |contact|
        contact.firstname.downcase.match(term) ||
          contact.lastname.downcase.match(term) ||
          contact.email.downcase.match(term) ||
          contact.phonenumber.downcase.match(term)
      end
    end

  end

end




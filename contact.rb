require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@conn = PG.connect({
    host: 'localhost',
    dbname: 'contacts'
  })

  attr_accessor :first_name, :last_name, :email
  attr_reader :id, :phone_numbers

  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(first_name, last_name, email, phone_numbers = [], id=nil)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @phone_numbers = phone_numbers
    @id = id
  end

  def add_phone_number(number)
    @phone_numbers << number if number.is_a? PhoneNumber
  end

  def save()

    unless id
      raw = @@conn.exec("INSERT INTO contacts (first_name, last_name, email) VALUES ( $1, $2, $3 ) RETURNING id",[first_name, last_name,email])
      @id = raw[0]['id']
      phone_numbers.each { |number| number.save }
    else
      @@conn.exec("UPDATE contacts SET first_name=$1, last_name=$2, email=$3 WHERE id=$4", [first_name, last_name, email, id])
      phone_numbers.each { |number| number.save }
    end
    self
  end

  def destroy
    phone_numbers.each { |number| number.destroy }
    @@conn.exec("DELETE FROM contacts WHERE id=$1",[id])
    self
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      output = []
      @@conn.exec("SELECT * FROM contacts").each do |row|
        output << Contact.new(row['first_name'],row['last_name'],row['email'],PhoneNumber.all_for_id(row['id']),row['id'])
      end
      output
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param first_name [String] the new contact's first name
    # @param last_name [String] the new contact's last name
    # @param email [String] the contact's email
    # @param phone_numbers [Hash]={} the contact's phone numbers
    # @return [Contact] Contact created
    def create(first_name, last_name, email, phone_numbers={})
      Contact.new(first_name, last_name, email, phone_numbers).save
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      raw = @@conn.exec("SELECT * FROM contacts WHERE id=$1::int",[id]).first
      return nil unless raw
      Contact.new(raw['first_name'],raw['last_name'],raw['email'],PhoneNumber.all_for_id(raw['id']),raw['id'])
    end

    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      raw = @@conn.exec("SELECT * FROM contacts WHERE first_name LIKE ('%' || $1 || '%') or last_name LIKE ('%' || $1 || '%') or email LIKE ('%' || $1 || '%')",[term])
      output = []
      raw.each do |contact|
        output << Contact.new(contact['first_name'],contact['last_name'],contact['email'],PhoneNumber.all_for_id(contact['id']),contact['id'])
      end
      output
    end

  end

end

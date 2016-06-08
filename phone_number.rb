require 'pg'

class PhoneNumber

  @@conn = PG.connect({
    host: 'localhost',
    dbname: 'contacts'
  })

  attr_accessor :phone_number, :contact_id
  attr_reader :id

  def initialize(phone_number, contact_id, id=nil)
    @phone_number = phone_number
    @contact_id = contact_id
    @id = id
  end

  def update()

    unless id
      @@conn.exec("INSERT INTO phone_numbers (phone_number, contact_id) VALUES ( $1, $2::int)",[phone_number,contact_id])
    end
  end

  class << self

    def all_for_id(contact_id)
      out = []
      @@conn.exec("SELECT * FROM phone_numbers WHERE contact_id=$1::int",[contact_id]).each do |row|
        out << PhoneNumber.new(row['phone_number'],row['contact_id'],row['id'])
      end
      out
    end
  end
end

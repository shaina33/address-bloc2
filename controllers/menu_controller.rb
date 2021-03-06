require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.first
  end

  def main_menu
    puts "'#{@address_book.name}' Address Book Selected\n#{@address_book.entries.count} entries"
    puts "0 - Switch AddressBook"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    # for testing
    puts "6 - Test"
    
    print "Enter your selection: "
    

    selection = gets.to_i

    case selection
      when 0
        system "clear"
        select_address_book_menu
        main_menu
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "Good-bye!"
        exit(0)
      # for testing
      when 6
        system "clear"
        test_function
        main_menu
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end
  
  def select_address_book_menu
    puts "Select an AddressBook:"
    AddressBook.all.each_with_index do |address_book, index|
      puts "#{index} - #{address_book.name}"
    end
    index = gets.chomp.to_i
    @address_book = AddressBook.find(index + 1)
    system "clear"
    return if @address_book
    puts "PLease select a valid index"
    select_address_book_menu
  end
  
  def view_all_entries
    @address_book.entries.each do |entry|
      system "clear"
      puts "Entry from #{entry.address_book.name}"
      puts entry.to_s
      entry_submenu(entry)
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    address_book.add_entry(name, phone, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = @address_book.find_entry(name)
    system "clear"
    if match && (match != [])
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
        system "clear"
        puts "#{entry.name} has been deleted"
        main_menu
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    Entry.destroy(entry.id)
  end

  def edit_entry(entry)
    updates = {}
    print "Updated name: "
    name = gets.chomp
    updates[:name] = name unless name.empty?
    print "Updated phone number: "
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?
    print "Updated email: "
    email = gets.chomp
    updates[:email] = email unless email.empty?
    entry.update_attributes(updates)
    system "clear"
    puts "Updated entry:"
    puts Entry.find(entry.id)
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        edit_entry(entry)
        system "clear"
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end
  
  def test_function
    # puts "No test function is currently active"
    # print "testing input: "
    # input = gets.chomp
    # output = 'no output'
    
    # output = BlocRecord::Utility.camelCase(input)
    
    # Entry.find_each do |entry|
    #   puts entry.name
    # end
    
    # Entry.find_each(start: 2, batch_size: 4) do |entry|
    #   puts entry.name
    # end
    
    # Entry.find_in_batches(start: 3, batch_size: 2) do |entries, batch|
    #   puts "New Batch, Number #{batch}"
    #   entries.each{ |entry| puts entry.name }
    # end
    
    # Entry.order(:name).each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order("name DESC").each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order("name ASC, phone_number DESC").each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order("name ASC", "phone_number DESC").each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order(:name, :phone_number).each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order(name: :asc, phone_number: :desc).each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    # Entry.order(:name, phone_number: :desc).each { |entry| puts "#{entry.name} / #{entry.phone_number}" }
    
    # people = { 1 => { "name" => "David" }, 2 => { "phone_number" => "123-456-0987" } }
    # Entry.update(people.keys, people.values)
    # main_menu
    
    # person = Entry.where(name: 'Jin').first
    # person.update_name("Ginny")
    # person.update_phone_number("222-333-4567")
    # puts Entry.where(name: 'Ginny').first
    
    # AddressBook.join(entrys: :dog)
    
    # person = Entry.where(name: 'hi').take
    # person = Entry.where(name: 'Sally').where(phone_number: '999-999-9999')
    # person = Entry.where(name: 'Sally').not(phone_number: '999-999-9999')
    # puts person
    
    # Entry.destroy(2,3)
    # Entry.first.destroy
    # Entry.destroy_all(name: 'Jane')
    # Entry.destroy_all
    # Entry.destroy_all("phone_number = '999-999-9999'")
    # Entry.destroy_all("phone_number = ?", '111-111-1111')
    # Entry.where(name: 'Sally').destroy_all
    
    # puts "output is: "
    # puts output
  end
end


class NewGem::CLI

 


  def call
    puts "Would you like to search for shows by date or by venue?"
    input = gets.strip
    if input == "date"
      date_listings
    elsif input == "venue"
      venue_listings
    else
      puts "I didn't understand the request. Choose date or venue."
    end
  end


  def date_listings
    puts "these are today's shows..."
    home = Nokogiri::HTML(open("http://www.ohmyrockness.com/shows"))
    binding.pry
  end


  def venue_listings
    puts "what venue would you like to view?"
    input = gets.strip
    site = Nokogiri::HTML(open("http://www.ohmyrockness.com/venues/#{input}"))
    binding.pry
  end





end
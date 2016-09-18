require 'pry'

class ShowListings::CLI
  
  def call
    puts "Hello! Would you like to check out today's shows or search by venue?"
    initial_choice = gets.strip
    while !initial_choice.include?("today") && !initial_choice.include?("venue")
      puts "\n"
      puts "I didn't understand your response."
      puts "\n"
      sleep(0.5)
      call
    end
    if initial_choice.include?("today")
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
      @choice = ShowListings::Scraper.new(@home)
      @choice.today
    elsif initial_choice.include?("venue")
      puts "\n"
      puts "Which venue would you like to check out? (NOTE: please enter the FULL name of the venue without any punctuation!)"
      @venue_choice = gets.chomp.gsub(/\s/, '-')
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@venue_choice}"))
      @choice = ShowListings::Scraper.new(@home)
      @choice.venue
    end
  end

end
class ShowListings::CLI
  
  def call
    puts "Would you like to check out today's shows or search by venue?"
    @initial_choice = gets.strip.downcase
    while !@initial_choice.include?("today") && !@initial_choice.include?("venue")
      puts "\nI didn't understand your response."
      puts
      sleep(0.5)
      call
    end
    if @initial_choice.include?("today")
      home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
      choice = ShowListings::Scraper.new(home)
      choice.today
    elsif @initial_choice.include?("venue")
      puts "\nWhich venue would you like to check out? (NOTE: please enter the FULL name of the venue without any punctuation!)"
      venue_choice = gets.chomp.gsub(/\s/, '-')
      begin 
        home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{venue_choice}"))
        while !home.to_s.include?("ds-event-category-music")
          puts "\nThere aren't any shows scheduled at #{venue_choice.split("-").each {|w| w.capitalize!}.join(" ")}."
          puts
          sleep(0.5)
          call
        end
      rescue OpenURI::HTTPError
        puts "\nSorry, I couldn't find that venue. Please try again."
        puts      
        call
      end
      choice = ShowListings::Scraper.new(home, venue_choice)
      choice.venue
    end
  end
end
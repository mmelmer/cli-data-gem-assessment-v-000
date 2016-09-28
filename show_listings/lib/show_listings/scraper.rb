class ShowListings::Scraper

  def initialize(home, venue_choice=nil)
    @home = home
    @venue_choice = venue_choice
    @num = 1
    @page = 1
  end

  def today
    @today = true
    puts "\nloading today's shows..."
    puts
    sleep(0.5)
    numbered_list
    date_choice
  end
 
  def venue
    @today = false
    @last_page = false
    numbered_list
    puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type 'more'. If you're done, type 'done'."
    venue_menu
  end

  def numbered_list
    puts
    @home.css('.ds-event-category-music').each_with_index do |event, idx|
      if @today == true
        puts "#{idx+1}. " + event.css(".ds-venue-name").text.strip
      elsif @today == false
        puts "#{idx+1}. " + event.css(".ds-event-date").text.strip
      end
      puts event.css(".ds-listing-event-title-text").text.strip
      puts event.css(".ds-event-time").text.strip.split(" ").first
      puts "\n"
      @num +=1
    end
  end

  def date_choice
    if @home.css(".ds-paging").text.strip.include?("Next Page")
      puts "If you'd like to learn about one of these shows, please enter its number. If you'd like to see more shows, type 'more'. If you're done, type 'done.'"
      today_menu
    else
      puts "You've reached the end of today's listings. Choose the number of the show you're interested in, type 'done' if you're done, or type 'restart' to go back to the beginning of today's listings."
      today_menu
    end
  end

  def today_menu
    today_entry = gets.strip.downcase
    @input_int = today_entry.to_i
    if today_entry.downcase == "done"
      puts "\nHave a nice day - check back tomorrow!"
      exit
    elsif today_entry.downcase == "more"
      @page +=1
      puts "\nHere are some more listings..."
      @home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?page=#{@page}")
      @num = 1
      numbered_list
      date_choice
    elsif today_entry.downcase == "restart"
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
      today
    elsif (0 < @input_int) && (@input_int < @num)
      buy_info_choice
    elsif @input_int > @num-1
      puts "Please enter a number between 1 and #{@num-1}"
      today_menu
    else
      puts "I didn't understand your input. Please try again."
      today_menu
    end
  end

  def venue_menu
    venue_entry = gets.chomp.downcase
    @input_int = venue_entry.to_i
    while (!venue_entry.include?("done") && !venue_entry.include?("more") && (@input_int == 0))
      puts "I didn't understand your input. Please enter the number of the show you're interested in, enter 'more' for another page of listings, or type 'done' to exit."
        venue_menu
    end
    if venue_entry.include?("done")
      puts "\nHave a nice day - check back tomorrow!"
      exit
    elsif venue_entry.include?("more")
      if @last_page == true
        puts "\n"
        puts "You've reached the end of the listings for this venue. Please enter the number of the show you're interested in, or type 'done' to exit."
        venue_menu
      end
      puts "\nChecking for more listings..."
      puts
      @page +=1
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@venue_choice}?page=#{@page}")) 
      @num = 1
      numbered_list
      if @home.css(".ds-paging").text.strip.include?("Next Page")
        puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type more. If you're done, type done."
        venue_menu
      else
        puts "You have reached the end of the listings for this venue. If you'd like to learn more about one of the shows, please enter its number. If you're done, type done."
        @last_page = true
        venue_menu
      end
    elsif ((0 < @input_int) && (@input_int < @num))
      buy_info_choice
    elsif @input_int > 0
      puts "Please enter a number between 1 and #{@num-1}"
      venue_menu
    end
  end

  def buy_info_choice
    listing = ShowListings::Listing.new(@home, @input_int)
    if @home.css(".ds-event-category-music")[@input_int-1].to_s.include?("ds-buy-tix")
      puts "\nWould you like to buy tickets for that show or just get more info?"
      buy_or_info = gets.chomp.downcase
      while (!buy_or_info.include?("tix") && !buy_or_info.include?("tick") && !buy_or_info.include?("info") && !buy_or_info.include?("buy"))
        puts "\nI didn't understand your input. Would you like to buy tickets for that show, or simply learn more information?"
        buy_or_info = gets.chomp.downcase
      end 
      if (buy_or_info.include?("tix") || buy_or_info.include?("tick") || buy_or_info.include?("buy")) 
        listing.open_buy
      elsif buy_or_info.include?("info")
        listing.open_info
      end
    else
      listing.open_info
    end
  end
end
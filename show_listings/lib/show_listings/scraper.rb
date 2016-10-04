class ShowListings::Scraper

  def self.scrape_events_today(url)
    url.css('.ds-event-category-music').each do |event|
      if event.css(".ds-listing-actions").to_s.include?("buy-tix")
        tix_url = event.css(".ds-buy-tix").css("a").first["href"]
      else
        tix_url = nil
      end
      ShowListings::Event.new({
        venue: event.css(".ds-venue-name").text.strip,
        artist: event.css(".ds-listing-event-title-text").text.strip,
        time: event.css(".ds-event-time").text.strip.split(" ").first,
        info_link: "http://nyc-shows.brooklynvegan.com/" + event.css("a").first["href"],
        buy_link: tix_url,
        date: url.css(".ds-list-break-date").text.strip
      })
    end
  end

  def self.scrape_events_venue(url)
    url.css('.ds-event-category-music').each do |event|
      if event.to_s.include?("buy-tix")
        buy = event.css(".ds-btn-container-buy-tix").css("a").first["href"]
      else
        buy = nil  
      end
      ShowListings::Event.new({
        venue: event.css(".ds-venue-name").text.strip,
        artist: event.css(".ds-listing-event-title-text").text.strip,
        time: event.css(".ds-event-time").text.strip.split(" ").first,
        info_link: "http://nyc-shows.brooklynvegan.com/" + event.css("a").first["href"],
        buy_link: buy,
        date: url.css(".ds-break-left").first.text.strip.split("\n")[1].strip,
      })
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
    elsif ((0 < @input_int) && (@input_int < @last))
      buy_info_choice
    elsif @input_int > 0
      puts "Please enter a number between 1 and #{@last}"
      venue_menu
    end
  end
  
end
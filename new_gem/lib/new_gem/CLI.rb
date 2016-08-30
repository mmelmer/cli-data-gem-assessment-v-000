class NewGem::CLI

  attr_accessor :i, :home, :page, :input_format, :last_page

  def call
    puts "Hello! Would you like to check out today's shows or search by venue?"
    input = gets.strip
    while !input.include?("today") && !input.include?("venue")
      puts "\n"
      puts "I didn't understand your response."
      puts "\n"
      sleep(0.5)
      call
    end
    if input.include?("today")
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
      date_listings
    elsif input.include?("venue")
      venue_listings
    end
  end

  def today_menu
    input = gets.strip
    input_int = input.to_i
      if input.downcase == "done"
        puts "\n"
        puts "Have a nice day - check back tomorrow!"
        exit
      elsif input.downcase == "more"
        @page +=1
        puts "\n"
        puts "Here are some more listings..."
        puts "\n"
        @home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?page=#{@page}")
        numbered_date_list
      elsif input.downcase == "restart"
        @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
        date_listings
      elsif (0 < input_int) && (input_int < num)
        puts "I'll open that site for you...(and this would open choice ##{input_int})"
        sleep (0.5)
        Launchy.open("tinymixtapes.com")
        #Launchy.open(...)
      else
        return "I didn't understand your input. Please try again."
      end
    end

  def numbered_date_list
    @home.css(".ds-event-category-music").each_with_index do |x, index|
      puts "#{index+1}. " + x.css(".ds-venue-name > a span").text + ":"
      puts x.css(".ds-listing-event-title-text").text
      puts x.css(".dtstart").text.strip
      puts "\n"
      end
    if @home.css(".ds-paging").text.strip.include?("Next Page")
      puts "If you'd like to learn about one of these shows, please enter its number. If you'd like to see more shows, type 'more'. If you're done, type 'done.'"
      today_menu
    else
      puts "You've reached the end of today's listings. Choose the number of the show you're interested in, type 'done' if you're done, or type 'restart' to go back to the beginning of today's listings."
      today_menu
    end
  end

  def date_listings
    @page = 1
    num = 1

    puts "\n"
    puts "loading today's shows..."
    puts "\n"
    sleep(0.5)
  
    if @home.css(".ds-paging").text.strip.include?("Next Page")
      numbered_date_list
      num +=1
      puts "If you'd like to find out more about one of these shows, enter its number. If you'd like to hear about more shows, type more. If you're finished, type done."
      today_menu
      #input = gets.strip
      #input_int = input.to_i
      #if input.downcase == "done"
      #  puts "\n"
      #  puts "Have a nice day - check back tomorrow!"
      #  exit
      #elsif input.downcase == "more"
      #  @page +=1
      #  @home = 
      #  puts "Here are some more listings..."
      #  puts "\n"
      #elsif (0 < input_int) && (input_int < num)
      #  puts "I'll open that site for you...(and this would open choice ##{input_int})"
      #  sleep (0.5)
      #  Launchy.open("tinymixtapes.com")
        #Launchy.open(...)
      #else
      #  return "I didn't understand your input. Please try again."
      #end
    else
      numbered_date_list
      puts "This is the end of today's listings. If you'd like to find out about one of these shows, type its number. If you'd like to exit, type done."
      today_menu
      #input_2 = gets.strip
      #return input_2
    end
  end

   def venue_menu
    input_2 = gets.chomp.downcase
    input_int = input_2.to_i
    while (!input_2.include?("done") && !input_2.include?("more") && (input_int == 0))
      puts "I didn't understand your input. Please enter the number of the show you're interested in, enter 'more' for another page of listings, or type 'done' to exit."
        venue_menu
    end
    if input_2.downcase.include?("done")
      puts "\n"
      puts "Have a nice day - check back tomorrow!"
      exit
    elsif input_2.downcase.include?("more")
      if @last_page == true
        puts "\n"
        puts "You've reached the end of the listings for this venue. Please enter the number of the show you're interested in, or type 'done' to exit."
        venue_menu
      end
      puts "\n"
      puts "Checking for more listings..."
      puts "\n"
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@input_format}?page=#{@page}"))
      
      @home.css('.ds-event-category-music').each_with_index do |x, idx|
        puts "#{idx+1}. " + x.css(".ds-event-date").text.strip
        puts x.css(".ds-listing-event-title-text").text.strip
        puts x.css(".ds-event-time").text.strip.split(" ").first
        puts "\n"
        @i +=1
      end
      @page +=1
      if @home.css(".ds-paging").text.strip.include?("Next page")
        puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type more. If you're done, type done."
        venue_menu
      else
        puts "You have reached the end of the listings for this venue. If you'd like to learn more about one of the shows, please enter its number. If you're done, type done."
        @last_page = true
        venue_menu
      end
    elsif ((0 < input_int) && (input_int < @i))
      if @home.css(".ds-event-category-music")[input_int-1].to_s.include?("ds-buy-tix")
        puts "\n"
        puts "Would you like to buy tickets for that show or just get more info?"
        input_3 = gets.chomp
        while (!input_3.include?("tix") && !input_3.include?("tick") && !input_3.include?("info") && !input_3.include?("buy"))
           puts "I didn't understand your input. Would you like to buy tickets for that show, or simply learn more information?"
           input_3 = gets.chomp
        end 
        if (input_3.include?("tix") || input_3.include?("tick") || input_3.include?("buy")) 
          puts "\n"
          puts "You can buy tickets here..."
          sleep(0.5)
          Launchy.open(@home.css(".ds-event-category-music")[input_int-1].css(".ds-buy-tix").css("a").first["href"])
          exit
        elsif input_3.include?("info")
          puts "Opening the page for that show..."
          base = "http://nyc-shows.brooklynvegan.com/"
          extension = @home.css(".ds-event-category-music")[input_int-1].css("a").first["href"]
          url = base + extension.to_s
          sleep(0.5)
          Launchy.open(url)
          exit
        end
      else
        puts "Opening the page for that show:"
        base = "http://nyc-shows.brooklynvegan.com/"
        extension = @home.css(".ds-event-category-music")[input_int-1].css("a").first["href"]
        url = base + extension.to_s
        sleep(0.5)
        Launchy.open(url)
        exit
      end
    elsif input_int > 0
      puts "Please enter a number between 1 and #{@i-1}"
      venue_menu
    end
  end

  def venue_listings
    @i = 1
    @page = 2
    @last_page = false
    puts "\n"
    puts "Which venue would you like to check out? (NOTE: please enter the FULL name of the venue without any punctuation!)"
    input = gets.chomp
    @input_format = input.gsub(/\s/, '-')
    @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@input_format}"))
    puts "\n"
    if !@home.to_s.include?("ds-event-category-music")
      puts "There aren't any shows scheduled at #{input.split.each {|w| w.capitalize!}.join(" ")}."
      venue_listings
    else
      @home.css('.ds-event-category-music').each_with_index do |x, idx|
        puts "#{idx+1}. " + x.css(".ds-event-date").text.strip
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".ds-event-time").text.strip.split(" ").first
        puts "\n"
        @i +=1
      end
    end
    puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type 'more'. If you're done, type 'done'."
    venue_menu
  rescue OpenURI::HTTPError
    puts "\n"
    puts "Sorry, I couldn't find that venue. Please try again."      
    venue_listings
    end  
  end

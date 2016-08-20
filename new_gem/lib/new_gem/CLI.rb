class NewGem::CLI

  attr_accessor :i, :home, :page, :input_format

  def call
    puts "Hello! Would you like to check out today's shows or search by venue?"
    input = gets.strip
    while !input.include?("today") && !input.include?("venue")
      puts "I didn't understand your response."
      call
    end
    if input.include?("today")
      date_listings
    elsif input.include?("venue")
      venue_listings
    end
  end

# def today_menu
    #input = gets.strip
      #input_int = input.to_i
      #if input.downcase == "done"
      #  puts "\n"
      #  puts "Have a nice day - check back tomorrow!"
      #  exit
      #elsif input.downcase == "more"
      #  @page +=1
      #  puts "Here are some more listings..."
      #  puts "\n"
        # @home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?@page=#{@page}")
      #elsif (0 < input_int) && (input_int < num)
      #  puts "I'll open that site for you...(and this would open choice ##{input_int})"
      #  sleep (0.5)
      #  Launchy.open("tinymixtapes.com")
        #Launchy.open(...)
      #else
      #  puts "I didn't understand your input. Please try again."
      #      choose_by_num
      #end      


  def date_listings
    @page = 1
    num = 1
    @@home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))

    puts "\n"
    puts "loading today's shows..."
    puts "\n"
    
    if @home.css(".ds-paging").text.strip.include?("Next page")
      @home.css(".ds-event-category-music").each_with_index do |x, index|
        puts "#{index+1}. " + x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip.split(" ").first
        puts "\n"
        num +=1
      end
      puts "If you'd like to find out more about one of these shows, enter its number. If you'd like to hear about more shows, type more. If you're finished, type done."
      # today_menu
      input = gets.strip
      input_int = input.to_i
      if input.downcase == "done"
        puts "\n"
        puts "Have a nice day - check back tomorrow!"
        exit
      elsif input.downcase == "more"
        @page +=1
        puts "Here are some more listings..."
        puts "\n"
        # @home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?@page=#{@page}")
      elsif (0 < input_int) && (input_int < num)
        puts "I'll open that site for you...(and this would open choice ##{input_int})"
        sleep (0.5)
        Launchy.open("tinymixtapes.com")
        #Launchy.open(...)
      else
        return "I didn't understand your input. Please try again."
      end
      # <-- end today_menu
    else
      @home.css(".ds-event-category-music").each_with_index do |x, index|
        puts "#{index+1}. " + x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip
        puts "\n"
        puts "This is the end of today's listings. If you'd like to find out about one of these shows, type its number. If you'd like to exit, type done."
        # today_menu
        input_2 = gets.strip
        return input_2
      end
    # <-- end today_menu
    end
  end

   def venue_menu
    input_2 = gets.chomp.downcase
    input_int = input_2.to_i
    while (!input_2.include?("done") && !input_2.include?("more") && (input_int == 0))
      puts "I didn't understand your input. Would you like to buy tickets or just get more info?"
        venue_menu
    end
    if input_2.downcase == "done"
      puts "\n"
      puts "Have a nice day - check back tomorrow!"
      exit
    elsif input_2.downcase == "more"
      puts "Here are some more listings..."
      puts "\n"
      i = 1
      @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@input_format}?page=#{@page}"))
      binding.pry
      @home.css('.ds-event-category-music').each_with_index do |x, idx|
        puts "#{idx+1}. " + x.css(".ds-event-date").text.strip
        puts x.css(".ds-listing-event-title-text").text.strip
        puts x.css(".ds-event-time").text.strip.split(" ").first
        puts "\n"
        i +=1
      end
      @page +=1
    elsif ((0 < input_int) && (input_int < @i))
      if @home.css(".ds-event-category-music")[input_int-1].to_s.include?("ds-buy-tix")
        puts "Would you like to buy tickets for that show or just get more info?"
        input_3 = gets.chomp
        if (input_3.include?("tix") || input_3.include?("tick"))
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
        else
          puts "I didn't understand your input. Please enter more, exit, or the number of your selection."
          venue_menu
        end
      else
        puts "Opening the page for that show:"
        base = "http://nyc-shows.brooklynvegan.com/"
        extension = @home.css(".ds-event-category-music")[input_int-1].css("a").first["href"]
        url = base + extension.to_s
        Launchy.open(url)
        exit
      end
    elsif input_int > 0
      puts "Please enter a number between 1 and #{i-1}"
      venue_menu
    end
  end

  def venue_listings
    @i = 1
    @page = 2
    puts "Which venue would you like to check out? (NOTE: please enter the FULL name of the venue without any punctuation!)"
    input = gets.chomp
    @input_format = input.gsub(/\s/, '-')
    @home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{@input_format}"))
    puts "\n"
    puts "\n"
    @home.css('.ds-event-category-music').each_with_index do |x, idx|
      puts "#{idx+1}. " + x.css(".ds-event-date").text.strip
      puts x.css(".ds-listing-event-title-text").text
      puts x.css(".ds-event-time").text.strip.split(" ").first
      puts "\n"
      @i +=1
    end
    puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type more. If you're done, type done."
    venue_menu
  end  

end

 # def venue_show_selection
 #   input = ""
 #   yes = ["yes", "Yes", "YES", "Y", "y"]
 #   no = ["no", "No", "NO", "N", "n"]
 #   puts "Would you like to learn more about any of these shows?"
 #   input = gets.strip
 #   while !yes.include?(input) && no.include?(input)
 #     puts "I didn't understand your input. Would you like to hear about any of these shows?"
 #   end
 #   if yes.include?(input)
 #     puts "Enter the date of the show you'd like to see, formatted MM/DD."
 #     date = gets.strip
 #     <link to show page based on date entered>
 #   elsif no.include?(input)
 #     puts "goodbye."
 #   end
 # end

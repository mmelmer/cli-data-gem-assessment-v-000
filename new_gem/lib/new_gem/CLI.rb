class NewGem::CLI

  attr_accessor :i

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

  def date_listings
    @i = 2
    num = 1
    #while home.css(".ds-paging").text.strip.include?("Next Page")
    puts "\n"
    puts "loading today's shows..."
    puts "\n"
    home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
    
    if home.css(".ds-paging").text.strip.include?("Next Page")
      home.css(".ds-event-category-music").each_with_index do |x, index|
        puts "#{index+1}. " + x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip 
        puts "\n"
        num +=1
      end 
      # home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?page=#{i}")
      puts "If you'd like to find out about one of these shows, enter its number. If you'd like to hear about more shows, type more. If you're finished, type done."
      input_2 = gets.strip
      if input_2.is_a?(Integer) && ((0 < input_2) && (input_2 < num))
        return "I'll open that site for you..."
        Launchy.open("tinymixtapes.com")
      elsif input_2 == "more"
        return "Here's the next page of shows..."
        # i += 1
      elsif input_2 == "done"
        return "Goodbye. Check back tomorrow!"
      else
        return "I didn't understand your input. Please try again."
      end
    else
      home.css(".ds-event-category-music").each_with_index do |x, index|
        puts "#{index+1}. " + x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip 
        puts "\n"
        puts "This is the end of today's listings. If you'd like to find out about one of these shows, type its number. If you're done, type done."
        input_2 = gets.strip
        return input_2
      end
    end
  end

  def venue_listings
    puts "Which venue would you like to check out?"
    input = gets.chomp
    input_format = input.gsub(/\s/, '-')
    cap = input.split(" ").each {|word| word.capitalize!}.join(" ")
    home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{input_format}"))
    puts "\n"
    puts "These are the upcoming shows at #{cap}:"
    puts "\n"
    i = 1
    home.css('.ds-event-category-music').each_with_index do |x, idx|
      puts "#{idx+1}. " + x.css(".ds-event-date").text.strip
      puts x.css(".ds-listing-event-title-text").text
      puts x.css(".ds-event-time").text.strip
      puts "\n"
      i +=1
    end
    binding.pry
    puts "Would you like to find out more about any of these shows? If so, enter the show's number. If you want to see more shows, type more. If you're done, type done."
    input_2 = gets.chomp
    input_int = input_2.to_i
    if input_2.downcase == "done"
      puts "\n"
      puts "Have a nice day - check back tomorrow!"
    elsif input_2.downcase == "more"
      puts "Here are some more listings..."
      # recursive?
    elsif ((0 < input_int) && (input_int < i))
      if home.css(".ds-event-category-music")[input_int-1].to_s.include?("ds-buy-tix")
        puts "Would you like to buy tickets for that show or just get more info?"
        input_3 = gets.chomp
        if (input_3.include?("tix") || input_3.include?("tick"))
          puts "You can buy tickets here:"
          Launchy.open(home.css(".ds-event-category-music")[input_int-1].css(".ds-buy-tix").css("a").first["href"])
        elsif input_3.include?("info")
          puts "Opening the page for that show:"
          base = "http://nyc-shows.brooklynvegan.com/"
          extension = home.css(".ds-event-category-music")[input_int-1].css("a").first["href"]
          url = base + extension.to_s
          Launchy.open(url)
        else
          puts "I didn't understand your input. Would you like to buy tickets or just get more info?"
        end
      else
        puts "Opening the page for that show:"
        base = "http://nyc-shows.brooklynvegan.com/"
        extension = home.css(".ds-event-category-music")[input_int-1].css("a").first["href"]
        url = base + extension.to_s
        Launchy.open(url)
      end
    elsif input_int > 0
      puts "Please enter a number between 1 and #{i-1}"
    else
      puts "Please enter the number of the show you'd like to learn more about."
    end
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

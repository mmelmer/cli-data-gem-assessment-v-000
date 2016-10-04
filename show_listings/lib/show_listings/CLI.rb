class ShowListings::CLI
  
  def call
    puts "Would you like to check out today's shows or search by venue?"
    input = gets.strip.downcase
    while !input.include?("today") && !input.include?("venue")
      puts "\nI didn't understand your response."
      puts
      sleep(0.5)
      call
    end
    if input.include?("today")
      @url = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
      choice = ShowListings::Scraper.scrape_events_today(@url)
      ShowListings::Event.all.each_with_index do |event, index|
        puts "#{index + 1}. #{event.artist}"
        puts "#{event.venue}"
        puts "#{event.time}"
        puts
      end
      selection
    elsif input.include?("venue")
      puts "\nWhich venue would you like to check out? (NOTE: please enter the FULL name of the venue without any punctuation!)"
      venue_choice = gets.chomp.gsub(/\s/, '-')
      begin
      @url = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/venues/#{venue_choice}"))
        while !@url.to_s.include?("ds-event-category-music")
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
      choice = ShowListings::Scraper.scrape_events_venue(@url)
      ShowListings::Event.all.each_with_index do |event, index|
        puts "#{index + 1}. #{event.artist}"
        puts "#{event.date}"
        puts "#{event.time}"
        puts 
        end
      selection 
    end
  end

  def selection
    @list = ShowListings::Event.all
    @last = @list.length.to_i
    puts "If you'd like to learn about one of these shows, please enter its number. If you'd like to start over, type 'restart'. If you're done, type 'done.'"
    selection_menu
  end

  def selection_menu 
    menu_selection = gets.strip.downcase
    @selection_int = menu_selection.to_i
    if menu_selection.include?("done")
      puts "\nHave a nice day - check back tomorrow!"
      exit
    elsif menu_selection.include?("restart")
      ShowListings::Event.reset_all
      call
    elsif
      @selection_int > @last
      puts "Please enter a number between 1 and #{@last}."
      selection_menu
    elsif (0 < @selection_int) && @selection_int <= @last
      show_menu
    else
      puts "I didnt understand your input. Please try again."
      selection_menu
    end
  end

  def show_menu
    puts
    puts "What would you like to learn about this show? Please enter 'artist', 'venue', 'date', 'time', 'info', or 'tickets'. You can always type 'done' to exit, or 'restart' to start over."
    chosen_event = @list[@selection_int-1]
    show_selection = gets.strip.downcase
    if show_selection.include?("venue")
      puts
      puts "This show is at #{chosen_event.venue}."
      sleep(0.5)
      show_menu
    elsif show_selection.include?("time")
      puts
      puts "This show starts at #{chosen_event.time}."
      sleep(0.5)
      show_menu
    elsif show_selection.include?("date")
      puts
      puts "This show is on #{chosen_event.date}."
      sleep(0.5)
      show_menu
    elsif show_selection.include?("artist")
      puts
      puts "The following artists will be performining at this show:"
      sleep(0.5)
      puts chosen_event.artist
      sleep(0.5)
      show_menu
    elsif show_selection.include?("info")
      puts
      puts "I'll send you to that page - goodbye!"
      sleep(0.5)
      Launchy.open(chosen_event.info_link)
      exit
    elsif show_selection.include?("tickets")
      if chosen_event.buy_link == nil
        puts
        puts "Sorry, there's no direct ticket link; you can find more info here:"
        sleep(0.5)
        Launchy.open(chosen_event.info_link)
        exit
      else
        puts
        puts "You can buy tickets here:"
        sleep(0.5)
        Launchy.open(chosen_event.buy_link)
        exit
      end
    elsif show_selection.include?("done")
        puts
        puts "Goodnight - check back tomorrow!"
        exit
    elsif show_selection.include?("restart")
      ShowListings::Event.reset_all
      call
    else
      puts
      puts "I didn't understand your input."
      sleep(0.5)
      show_menu
    end
  end
      
end
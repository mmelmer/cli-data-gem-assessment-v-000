class NewGem::CLI


require 'open-uri'
require 'nokogiri'
 
 @@shows_by_date = []
 @@shows_by_venue = []

  def call
    puts "Would you like to check out today's shows or search by venue?"
    input = gets.strip
    while !input.include?("today") && !input.include?("venue")
      puts "I didn't understand your response."
      call
    end
    if input.include?("today") #<---check that include? method works on strings
      date_listings
    elsif input.include?("venue")
      venue_listings
    end
  end


  def date_listings
    i = 2
    #while home.css(".ds-paging").text.strip.include?("Next Page")
    puts "loading today's shows..."
    puts "\n"
    home = Nokogiri::HTML(open("http://nyc-shows.brooklynvegan.com/events/today"))
    while home.css(".ds-paging").text.strip.include?("Next Page")
      home.css(".ds-event-category-music").each do |x|
        puts x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip 
        puts "\n"
        home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?page=#{i}")
      end 
      i += 1
    end
    home.css(".ds-event-category-music").each do |x|
        puts x.css(".ds-venue-name > a span").text + ":"
        puts x.css(".ds-listing-event-title-text").text
        puts x.css(".dtstart").text.strip 
        puts "\n"
      end

      
    #  home = Nokogiri::HTML(open"http://nyc-shows.brooklynvegan.com/events/today?page=#{i}")
    #  i +=1
    #home.css(".ds-event-category-music a span").each {|x| puts x.text}

    #home.css(".ds-listing-details").css(".dtstart").each {|x| puts x.text.strip }
    binding.pry
  end



  def listings_by_date
  end

  def venue_listings
    puts "Which venue would you like to check out?"
    input = gets.strip
    #headless = Headless.new
    #headless.start
    #info = Watir::Browser.new 
    #info.goto "http://www.ohmyrockness.com/venues/#{input}"
    #site = Nokogiri::HTML.parse(info.html)
    #headless.destroy
    binding.pry
    puts "Here are the upcoming shows at #{input}:"
    # <show tag>.each do |show| puts "#{date tag}: #{each band tag}, #{time formatted within minimal digits}"
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

end



# pry(#<NewGem::CLI>)> site.css("#upcomingShows").first.children.first.children[5].children[5].children.text.strip.split(", ")
#

# home.css(".ds-listing-details").first.css(".ds-venue-name").first






# => venue name:   
#   home.css(".ds-listing-details").first.css(".ds-venue-name > a span").text
#
# => band name:
#   home.css(".ds-event-category-music a span")[1].text

#  => show time:
#   home.css(".ds-listing-details").first.css(".dtstart").text.strip 


# http://nyc-shows.brooklynvegan.com/events/2016/08/05
# http://nyc-shows.brooklynvegan.com/venues/barbes



#home.css(".ds-event-category-music").first
# 
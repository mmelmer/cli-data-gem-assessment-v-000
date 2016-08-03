class NewGem::CLI


require 'open-uri'
require 'nokogiri'
require 'watir'
require 'headless'
 


  def call
    puts "Would you like to view today's shows or search by venue?"
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
    puts "these are today's shows..."
    home = Nokogiri::HTML(open("http://www.ohmyrockness.com/shows"))
    binding.pry
  end



  def listings_by_date
  end

  def venue_listings
    puts "Which venue would you like to check out?"
    input = gets.strip
    headless = Headless.new
    headless.start
    info = Watir::Browser.new 
    info.goto "http://www.ohmyrockness.com/venues/#{input}"
    site = Nokogiri::HTML.parse(info.html)
    headless.destroy
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
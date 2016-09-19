class ShowListings::Listing

  def initialize(home, selection_number)
    @home = home
    @selection_number = selection_number
  end

  def buy_link
    @home.css(".ds-event-category-music")[@selection_number-1].css(".ds-buy-tix").css("a").first["href"]
  end

  def info_link
    "http://nyc-shows.brooklynvegan.com/" + @home.css(".ds-event-category-music")[@selection_number-1].css("a").first["href"]
  end

  def open_buy
    puts "\n"
    puts "You can buy tickets here..."
    sleep(0.5)
    Launchy.open(buy_link)
  end

  def open_info
    puts "\n"
    puts "Opening the page for that show..."
    sleep(0.5)
    Launchy.open(info_link)
  end

end
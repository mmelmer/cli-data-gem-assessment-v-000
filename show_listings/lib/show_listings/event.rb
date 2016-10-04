class ShowListings::Event

  attr_accessor :venue, :time, :artist, :info_link, :buy_link, :date, :number, :last

  @@all = []

  def initialize(attributes={})
    @venue = attributes[:venue]
    @time = attributes[:time]
    @artist = attributes[:artist]
    @info_link = attributes[:info_link]
    @buy_link = attributes[:buy_link]
    @date = attributes[:date]
    @last = attributes[:last]
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset_all
    @@all = []
  end

end

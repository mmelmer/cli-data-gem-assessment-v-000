# Installation
Add the following to your Gemfile:
  gem 'show_listings'  

And then execute:
  $ gem install show_listings

# Overview
This gem allows the user to seach through NYC concert listings found on brooklynvegan.com To start program, simply run the bin/show_listings.rb file. 

Upon starting the program, you will be prompted to choose either a list of the day's upcoming shows, or the upcoming shows at a particular venue. 

If you choose the 'today' option, the program will provide you with the first page of shows scheduled for that day. At the end of the initial page, you will be asked to either choose one of the shows listed, enter 'done' to exit the program, or enter 'more' to view the next page of shows. Each page contains a numbered list of shows, and to learn more about one of those shows, simply enter its number when prompted. The numbering system will start over with a new list starting at '1' if the next page is chosen. You can continue choosing 'more' at the end of each page until you reach the end of the listings. At this point, you can choose a show, exit, or type 'restart' to go back to the first numbered page of shows. When you choose a numered show listing, you will be given the option of buying tickets for that show (if such an option exists on the Brooklyn Vegan page), or simply forwarded to an info page.

If you choose the 'venue' option, you will prompted the enter the name of a NYC music venue. Note that, for this program to work correctly, you need to spell out the entire name of the venue without any puncuation. If you choose a valid venue, the program will begin listing the shows at the venue, in chronological order, in the same manner as in the 'today' option above. If there are no shows currently scheduled, the program will inform you of this and instruct you to start over. The program will also inform you if it cannot find a venue by the name you entered. The program will exit on its own once a final selection has been made. 

# Contributor's Guide
After checking out the repo, run bin/setup to install dependencies. Then, run rake spec to run the tests. You can also run bin/console for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run bundle exec rake install. To release a new version, update the version number in version.rb, and then run bundle exec rake release, which will create a git tag for the version, push git commits and tags, and push the .gem file to rubygems.org.

Bug reports and pull requests are welcome on GitHub at: 
  https://github.com/mmelmer/cli-data-gem-assessment-v-000.

#License

The gem is available as open source under the terms of the MIT License, which can be found at: 
  https://opensource.org/licenses/MIT

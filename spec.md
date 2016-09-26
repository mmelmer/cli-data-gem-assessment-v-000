# Specifications for the CLI Assessment

Specs:
- [x] Have a CLI for interfacing with the application
  - bin/show_listings instantiates CLI interface via CLI.call method
- [x] Pull data from an external source
  - nokogiri scrapes info from brooklynvegan.com, depending on user's preferences
- [x] Implement both list and detail views
  -user initially presented a list of 2 options: starting venue search or just viewing daily listings
  -choosing one of these options then either lists the day's shows or prompts the user for more input, followed by the list of shows at the chosen venue
  -once a final choice is made, the user is given the option of buying tickets (if this option is available for the specific show) or simply learning more information, which is opened in the user's default browser.

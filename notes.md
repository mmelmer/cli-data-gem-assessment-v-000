OMR tags:

-main site
-by date
  -date tag/today?
  -ticket link?
  -time/venue link?
-by venue
  -venue tag
  -artist link
  -time?
  -ticket link?








  other notes:
       to bring up read write etc rights:
          ls -lah
       to modify one of those files:
          chmod +x filename




CSS tags:
-venue:
  div class 'row vevent' ------ container for each night's listing
    within 'row vevent':
      -date/time: div class 'date dtstart' 
        -span class 'value-title'
          -'title' within this span contains date[/time]
          -text within this span contains day of week
        -span class 'smaller'
          -text within = properly formatted time of show
      -names of bands: div class 'bands summary'
        -profiled bands have a direct link to own page
          -a href
          -text = band name
        -nonprofiled
          -a class = 'non-profiled'
          -text of class = band name
          -also contains href
      -more info/tickets:
        -div class = 'tickets'
        -buy tickets: first a href
        -more info on show: span class 'hoffer'
          -first a href
      





The plan for "Dinner and a Show" is to help planning an eventing's activities (whether a date night, family vacation, etc).

The layout of the screens is as follows:
    First screen - list of upcoming dates, with details and ability to change each option, and add new date
    Dinner screen work flow:
        Select food type (segment control at the top of the screen for "Recipes" and "Restaurants")
        "Recipes" shows a list of recipe types
        -> Selecting a food type while in "Recipes" mode goes to list of recipes (filtered by original food type selection)
            Selecting a recipe goes to the recipes details
            Recipe screen should allow for setting a timer to know when to start preparing the food
        "Restaurants" shows a list of restaurant food types
        -> Selecting a food type while in "Restaurants" mode goes to list of restaurants in the area (filtered by original food type selection)
            Selecting a restaurant goes to the restaurant details
            Details screen should be able to call directly or go to website
    Entertainment screen work flow:
        Select entertainment type (movie, play, concert)
        List of events in the area
        Selecting an event goes to the event details
        Event details screen should allow for buying tickets, mapping the location, etc.
        
        
Other thoughts:
    Should there be another tab for "Gifts" to schedule buying flowers, candy, etc?
    Should there be another tab for "Itinerary" to summarize plans/schedule?
    Where does the user enter the time of the date?
    Should the user be prompted for "Review restaurant", "Review movie" or "Review concert" the next day?
    Use weather.gov service to check weather for the date
    
Screens and services used:
    Recipe listing/Recipe details - Pearson and Guardian
    Restaurant listing/Restaurant details - Yelp
    Event listing/Event details - NY Times, GetGlue, Patch?
    Follow-up reviews - Yelp, Foursquare, GetGlue?
    Check-ins? - Facebook, Twitter, Yelp, GetGlue
    
CoreData structures:
    Date
        id
        Dinner
        Event
        Recipe (optional)
        Weather forecast
    Dinner
        time
        Place
    Event
        time
        Place
    Place
        name
        location
        phone
        yelp url
        url
    Recipe
        document (save recipe document as whole for display)
        cooking time
        alert
    Weather forecasts
        time
        zip code
        image
        
        
        
        
        
        
# elm-clever-fuel

Welcome to my gas stations price comparator "CLEVER-FUEL" built with Elm!  
I'm using the  free plans from the [Tankkönig-Api](https://creativecommons.tankerkoenig.de/?page=info) and [PTV-Developer-Api](https://developer.myptv.com/Documentation/Geocoding%20API/QuickStart.htm) 

## What is CLEVER-FUEL

With "CLEVER-FUEL" you can display the best, cheapest and nearest gas stations in your area.
Look for gas stations in your area or throughout Germany and refuel at fair prices!

## How to use CLEVER-FUEL
- You can use the search field at the homepage to find certain places near you or in Germany.

You can search for:
- Cities ```["Berlin" or "10115 Berlin"]```
- Specific addresses ```["Pariser Platz 1, 10117 Berlin" or "Pariser Platz 1"]```

Press the search button to confirm your search.

- After your search confirmation you receive some filter options:
    
You can filter:
- Fuel type ``["SuperE5", "SuperE10", "Diesel"]``
- Sorting: ```["Price", "Distance"]``` 

(Distance to the location you typed in the search field)

- Radius: ```[From "1km - 25km"]```
- Only open: See only open gas stations 

Extras:
- You can click the name of the gas station to see the specific address information.

- You can click on the compass symbol, to open the gas station at "Google-Maps".


## How to run the Project
Open the project and run the following command in the project directory:
```bash
elm make src/Main.elm --output elm.js && mv elm.js ./src/
```
It's important that the generated ```elm.js``` file is in the ```src``` directory. 

After you run the command, you can simply open the ```index.html``` file. :)

For the development I used VS-Code.

```Have fun!```

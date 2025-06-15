#  🌤️ Weather App

A simple iOS weather application built with Swift and UIKit. It displays current weather, daily and hourly forecast, and allows users to add multiple cities to the list of favorites.

## 📲Features

- Search and add cities
- Display current weather condition
- Hourly forecast (24 hours) and daily forecast (5 days)
- Save favorite cities using UserDefaults
- Adaptive backgroud gradient depending on time of day and weather
- Fetch weather data using OpenWeather API

## ⚙️Technologies used

- Swift
- UIKit
- MVC
- Dependency Injection
- URLSession for networking
- UserDefaults for persistance
- OpenWeather API

## 📷Screenshots

### Main Screen
Adaptive, support light and dark modes.
[Main Dark Screen](Screenshots/Main (dark theme).png)
[Main Light Screen](Screenshots/Main (light theme).png)

###List of favorite cities
List appears on the main screens at once after you added a city to favorites, adaptive.
[Favorites Dark Screen](Screenshots/List of favorites (dark theme).png)
[Favorites Light Screen](Screenshots/List of favorites (light theme).png)

###Screen with detailed info about weather of a city
It has current weather, hourly and daily forecast, Background is adaptive depending on weather and daytime.
[Rainy Day City Screen](Screenshots/City (rainy day background).png)
[Clear Day City Screen](Screenshots/City (clear day background).png)
[Rainy Night City Screen](Screenshots/City (rainy night background).png)
[Clear Night City Screen](Screenshots/City (clear night background).png)

###Screen with error message
If a name of a city was spelled not correctly, there is no internet connection etc. user will see a message with explanation.
[City name is not correct case](Screenshots/City name is not correct case.png)
[Internet connection issue case](Screenshots/Internet connection issue case.png)

###Deleting functionality
User can delete any city from favorites list.
[Deleting a city from the list](Screenshots/Deleting the city from the list.png)

###Already in favorites notification
User will get a notification if tries to add city to favorites even though it's already there.
[Already in favorites notification](Screenshots/Already in favorites notification.png)

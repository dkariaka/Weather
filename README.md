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
![Main Dark Screen](Screenshots/Main%20(dark%20theme).png)
![Main Light Screen](Screenshots/Main%20(light%20theme).png)

###List of favorite cities
List appears on the main screens at once after you added a city to favorites, adaptive.
![Favorites Dark Screen](Screenshots/List%20of%20favorites%20(dark%20theme).png)
![Favorites Light Screen](Screenshots/List%20of%20favorites%20(light%20theme).png)

###Screen with detailed info about weather of a city
It has current weather, hourly and daily forecast, Background is adaptive depending on weather and daytime.
![Rainy Day City Screen](Screenshots/City%20(rainy%20day%20background).png)
![Clear Day City Screen](Screenshots/City%20(clear%20day%20background).png)
![Rainy Night City Screen](Screenshots/City%20(rainy%20night%20background).png)
![Clear Night City Screen](Screenshots/City%20(clear%20night%20background).png)

###Screen with error message
If a name of a city was spelled not correctly, there is no internet connection etc. user will see a message with explanation.
![City name is not correct case](Screenshots/City%20name%20is%20not%20correct%20case.png)
![Internet connection issue case](Screenshots/Internet%20connection%20issue%20case.png)

###Deleting functionality
User can delete any city from favorites list.
![Deleting a city from the list](Screenshots/Deleting%20the%20city%20from%20the%20list.png)

###Already in favorites notification
User will get a notification if tries to add city to favorites even though it's already there.
![Already in favorites notification](Screenshots/Already%20in%20favorites%20notification.png)

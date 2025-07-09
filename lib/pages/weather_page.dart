import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ta9sna/models/weather_model.dart';
import 'package:ta9sna/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('889958073e625d3625c22c453a948c6a');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny_clear.json'; // default to sunny
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/sunny_rain.json';
      case 'thunderstorm':
        return 'assets/rainy_thunder';
      case 'clear':
        return 'assets/sunny_clear.json';
      default:
        return 'assets/sunny_clear.json';
    }
  }

  // initial state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            // city name
            Text(
              _weather?.cityName.toUpperCase() ?? "loading city..",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
        leading: Icon(Icons.location_on),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            SizedBox(height: 120),

            // temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // weather condition
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

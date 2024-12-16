import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherServices = WeatherService('30874c5a07b3750e6ba67547c89c9468');
  Weather? _weather;
  bool _isLoading = true; // Track loading state

  // fetch weather
  _fetchWeather() async {
    // set loading to true before fetching data
    setState(() {
      _isLoading = true;
    });

    // get current city
    String cityName = await _weatherServices.getCurrentCity();

    // get weather for the city
    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false; // Set loading to false even if there's an error
      });
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
        title: const Text("Weather App"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading indicator when fetching
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City Name
                  Text(
                    _weather?.cityName ?? "Loading City...",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  // Weather Condition
                  Text(
                    '${_weather?.mainCondition}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),

                  // Temperature
                  Text(
                    "${_weather?.temperature.round()}°C",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                  ElevatedButton(
                    onPressed: _fetchWeather,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            11), // Correctly apply border radius
                      ),
                    ),
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:cewsng/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather> _data = [];
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchWeather("Abeokuta");
  }

  void _fetchWeather(String city) {
    _wf.currentWeatherByCityName(city).then((w) {
      setState(() {
        _weather = w;
        //print(w);
      });
    });

    queryForecast(city);
  }

  Future<void> queryForecast(String city) async {
    List<Weather> forecasts = await _wf.fiveDayForecastByCityName(city);
    setState(() {
      _data = forecasts;
      //print(_data);
    });
  }

  void _updateCity() {
    String city = _cityController.text;
    if (city.isNotEmpty) {
      _fetchWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _searchCity(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _locationHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              _datetimeInfo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _weatherIcon(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _currentTemp(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _extraInfo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
        _forecasts()
      ],
    );
  }

  Widget _searchCity() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: "Enter City name",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: _updateCity, child: const Text('Get Weather'))
            ],
          ),
        )
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _datetimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              " ${DateFormat("d, MMM y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}\u00B0C",
      style: const TextStyle(
          color: Colors.black, fontSize: 50, fontWeight: FontWeight.w500),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Temp Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}\u00B0C",
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Temp Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}\u00B0C",
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind Speed: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _forecasts() {
    return Column(
      children: [
        const Text(
          "Weather Forecast",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 25.0),
        ..._data.map((weather) {
          return Column(
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("h:mm a").format(weather.date!),
                      style: const TextStyle(fontSize: 35.0),
                    ),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("d MMM y").format(weather.date!),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                  ]),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://openweathermap.org/img/wn/${weather.weatherIcon}@4x.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weather.weatherDescription!,
                        style: const TextStyle(fontSize: 17.0),
                      )
                    ]),
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${weather.temperature?.celsius?.toStringAsFixed(0)}\u00B0C",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Temp Max: ${weather.tempMax?.celsius?.toStringAsFixed(0)}\u00B0C",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Temp Min: ${weather.tempMin?.celsius?.toStringAsFixed(0)}\u00B0C",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Wind Speed: ${weather.windSpeed?.toStringAsFixed(0)}m/s",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Humidity: ${weather.humidity?.toStringAsFixed(0)} %",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(),
              const SizedBox(
                height: 20.0,
              )
            ],
          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:final_project/secrets.dart';

// ignore: constant_identifier_names
enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherWidget extends StatefulWidget {
  @override
  const WeatherWidget({super.key});

  @override
  State createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String key = weather_api_key;
  late WeatherFactory ws;
  Weather? _data;
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, lon;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
    queryWeather();
  }

  void queryWeather() async {
    await _coordinateFetch();

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(lat!, lon!);
    setState(() {
      _data = weather;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget _weatherRepresentation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Place Name: ${_data!.areaName} [${_data!.country}]'),
        Text('Date: ${_data!.date}'),
        Text('Weather: ${_data!.weatherMain}'),
        Text('Temp: ${_data!.temperature}'),
        Text('(feels like): ${_data!.tempFeelsLike}'),
        Text('Wind: speed ${_data!.windSpeed}'),
      ],
    );
  }

  Widget _weatherAnalysis() {
    late String res;
    final int code = _data!.weatherConditionCode ?? -1;
    return Text(
      'Wanna do some workout?',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget contentFinishedDownload() {
    return Column(
      children: [
        _weatherAnalysis(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _weatherRepresentation(),
            Image.network(
                "http://openweathermap.org/img/w/${_data!.weatherIcon}.png"),
          ],
        ),
        _updateButton(),
      ],
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Column(children: [
        const Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: const EdgeInsets.only(top: 50),
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Press the button to download the Weather forecast',
          ),
          _updateButton(),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  void _savePosition(Position position) {
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  Future<void> _getLatestCoords() async {
    Position? pos = await Geolocator.getLastKnownPosition();

    if (pos != null) {
      _savePosition(pos);
    }
  }

  Future<void> _coordinateFetch() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot fetch your location');
    }

    await _getLatestCoords();

    Position pos = await Geolocator.getCurrentPosition();
    _savePosition(pos);
  }

  Widget _updateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(5),
          child: TextButton(
            onPressed: queryWeather,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            child: const Text(
              'update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: _resultView(),
    );
  }
}

class WeatherModel {
  final String city;
  final double temperature;
  final int humidity;
  final String description;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'],
      temperature: (json['temperature'] as num).toDouble(),
      humidity: json['humidity'],
      description: json['description'],
    );
  }
}

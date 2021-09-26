import 'package:getmecar/model/city.dart';

class Country {
  final String name;
  final String link;
  final String id;
  final List<City> cities;

  Country({
    required this.cities,
    required this.link,
    required this.name,
    required this.id,
  });
}

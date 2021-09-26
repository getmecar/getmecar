import 'package:flutter/cupertino.dart';
import 'package:getmecar/model/city.dart';
import 'package:getmecar/model/county.dart';
import 'package:getmecar/model/transport.dart';
import 'package:getmecar/services/get_me_car_service.dart';

class SearchProvider with ChangeNotifier {
  List<Country>? _countries;
  List<City>? _cities;
  List<Transport>? _transports;

  List<Country> get countries => _countries ?? [];

  List<City> get cities => _cities ?? [];

  List<Transport> get transports => _transports ?? [];

  Future<void> init() async {
    _countries = await GetMeCarService.getCountries();
    _countries!.sort((a, b) => a.name.compareTo(b.name));

    _cities = [];
    for (var country in _countries!) {
      _cities!.addAll(country.cities);
      _cities!.sort((a, b) => a.name.compareTo(b.name));
    }

    _transports = GetMeCarService.getTransport();

    notifyListeners();
  }

  City? findCity(String? name) {
    for (var city in _cities!) {
      if (city.name == name) {
        return city;
      }
    }
  }

  Country? findCountry(String? name) {
    for (var country in _countries!) {
      if (country.name == name) {
        return country;
      }
    }
  }

  Transport? findTransport(String? name) {
    for (var transport in _transports!) {
      if (transport.name == name) {
        return transport;
      }
    }
  }
}

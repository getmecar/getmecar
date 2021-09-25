import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_me_car/model/city.dart';
import 'package:get_me_car/model/county.dart';
import 'package:get_me_car/model/transport.dart';
import 'package:http/http.dart' as http;

abstract class GetMeCarService {
  static Future<List<Country>> getCountries() async {
    http.Response res = await http.get(Uri.parse('https://getmecar.ru/wp-content/themes/homey-child/cities.json'));
    Map<String, dynamic> jsonRes = await jsonDecode(res.body);

    final List<Country> countries = [];

    jsonRes.forEach((countryId, countryData) {
      Country country = new Country(cities: [], link: countryData['link'], name: countryData['name'], id: countryId);
      countryData['cities'].forEach((cityId, cityData) {
        country.cities.add(new City(name: cityData['name'], link: cityData['link'], id: cityId));
      });
      countries.add(country);
    });

    return countries;
  }

  static List<Transport> getTransport() {
    return [
      Transport(id: 'legkovoj-transport', name: 'Легковой транспорт'),
      Transport(id: 'passazhirskij-transport', name: 'Пассажирский транспорт'),
      Transport(id: 'gruzovoy-transport-i-spectehnika', name: 'Грузовики и спецтехника'),
      Transport(id: 'mototehnika1', name: 'Мототехника'),
      Transport(id: 'vodnyj-transport', name: 'Водный транспорт'),
      Transport(id: 'vozduh', name: 'Воздушная техника'),
    ];
  }

  static void sendToken(String uid) async {
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('GET TOKEN ERROR: $e');
    }

    if (token != null)
      await http.post(Uri.parse('https://getmecar.ru/api/register_token.php'), body: {'user_id': uid, 'token': token});
  }

  static void deleteToken(String uid) async {
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('GET TOKEN ERROR: $e');
    }

    if (token != null)
      await http.post(Uri.parse('https://getmecar.ru/api/remove_token.php'), body: {'user_id': uid, 'token': token});
  }
}

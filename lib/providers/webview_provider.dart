import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getmecar/services/get_me_car_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebviewProvider with ChangeNotifier {
  late SharedPreferences prefs;

  String _currentUrl = 'https://getmecar.ru/';
  String? _userId;
  bool? _isCatalog;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    if (_userId == 'null') _userId = null;
    notifyListeners();
  }

  void _saveData() async {
    await prefs.setString('user_id', _userId.toString());
  }

  bool get isCatalog => _isCatalog ?? false;

  set isCatalog(bool newValue) {
    _isCatalog = newValue;
    notifyListeners();
  }

  String get currentUrl => _currentUrl;

  String? get userId => _userId;

  set userId(String? newId) {
    if (_userId == newId) return;

    if (newId != null)
      GetMeCarService.sendToken(newId);
    else
      GetMeCarService.deleteToken(_userId!);
    _userId = newId;

    _saveData();
  }

  void openMain() {
    _currentUrl = 'https://getmecar.ru/';
    notifyListeners();
  }

  void openFaq() {
    _currentUrl = 'https://getmecar.ru/faq/';
    notifyListeners();
  }

  void openRegistrationHelp() {
    _currentUrl = 'https://getmecar.ru/pomosh-v-reg/';
    notifyListeners();
  }

  void openContacts() {
    _currentUrl = 'https://getmecar.ru/contact-us/';
    notifyListeners();
  }

  void openLogin() {
    print('user id : $_userId');
    if (_userId == null)
      _currentUrl = 'https://getmecar.ru/pomosh-v-reg/?log_in=true';
    else
      _currentUrl = 'https://getmecar.ru/lk';
    print('url : $_currentUrl');
    notifyListeners();
  }

  void openMenu() {
    _currentUrl = 'https://getmecar.ru/?log_in=true';
    notifyListeners();
  }

  void openAddTechnique() {
    _currentUrl = 'https://getmecar.ru/become-a-host/';
    notifyListeners();
  }

  void openTechnique({required String transportId, DateTime? timeStart, DateTime? timeEnd}) {
    String arrive = '';
    if (timeStart != null) {
      arrive = 'arrive=${timeStart.day}-${timeStart.month}-${timeStart.year}';
    }
    String depart = '';
    if (timeEnd != null) {
      depart = 'depart=${timeEnd.day}-${timeEnd.month}-${timeEnd.year}';
    }

    _currentUrl = 'https://getmecar.ru/tech_type/$transportId/?$arrive&$depart';
    _isCatalog = true;
    notifyListeners();
  }

  void openLocality(
      {required String? countryId, String? cityId, String? transportId, DateTime? timeStart, DateTime? timeEnd}) {
    /// arrive date
    String arrive = '';
    if (timeStart != null) {
      arrive = 'arrive=${timeStart.day}-${timeStart.month}-${timeStart.year}';
    }

    /// depart date
    String depart = '';
    if (timeEnd != null) {
      depart = 'depart=${timeEnd.day}-${timeEnd.month}-${timeEnd.year}';
    }

    ///transport type
    String transport = '';
    if (transportId != null) {
      transport = 'tech_cat=$transportId';
    }

    /// country & city
    String? localityId = cityId;
    String city = 'city=$cityId';
    if (cityId == null) {
      city = '';
      localityId = countryId;
    }

    _currentUrl = 'https://getmecar.ru/city/$localityId/?list_country=$countryId&$city&$transport&$arrive&$depart';
    print('NEW URL: $_currentUrl');
    _isCatalog = true;
    notifyListeners();
  }
}

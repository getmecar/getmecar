import 'package:flutter/material.dart';
import 'package:getmecar/components/big_button.dart';
import 'package:getmecar/components/drop_down_text_field.dart';
import 'package:getmecar/pages/webview_page.dart';
import 'package:getmecar/providers/search_provider.dart';
import 'package:getmecar/providers/webview_provider.dart';
import 'package:provider/provider.dart';

class TechniqueSearch extends StatefulWidget {
  @override
  _TechniqueSearchState createState() => _TechniqueSearchState();
}

class _TechniqueSearchState extends State<TechniqueSearch> {
  late SearchProvider _searchProvider;
  late WebviewProvider _webviewProvider;

  String? _currentCountry;
  String? _currentCity;
  String? _transport;
  DateTime? _timeStart;
  DateTime? _timeEnd;

  bool isError() {
    return !(_currentCity != null || _currentCountry != null || _transport != null);
  }

  @override
  Widget build(BuildContext context) {
    _searchProvider = Provider.of<SearchProvider>(context);
    _webviewProvider = Provider.of<WebviewProvider>(context);

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  child: DropDownTextField(
                      categories: _searchProvider.countries.map<String>((value) => value.name).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _currentCountry = newValue;
                          _currentCity = null;
                        });
                      },
                      hint: 'Страна')),
              Flexible(
                  child: DropDownTextField(
                      categories: (_currentCountry != null
                              ? _searchProvider.findCountry(_currentCountry!)!.cities
                              : _searchProvider.cities)
                          .map((value) => value.name)
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _currentCity = newValue;
                        });
                      },
                      hint: 'Город')),
            ],
          ),
          DropDownTextField(
              categories: _searchProvider.transports.map<String>((value) => value.name).toList(),
              onChanged: (newValue) {
                _transport = newValue;
              },
              hint: 'Выберите тип техники'),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      setState(() {
                        _timeStart = newDate;
                      });
                    },
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${_timeStart != null ? '${_timeStart!.day}-${_timeStart!.month}-${_timeStart!.year}' : 'Начало'}',
                            style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.65), letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      setState(() {
                        _timeEnd = newDate;
                      });
                    },
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${_timeEnd != null ? '${_timeEnd!.day}-${_timeEnd!.month}-${_timeEnd!.year}' : 'Возврат'}',
                            style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.65), letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          BigButton(
            text: 'Поиск техники',
            onTap: () {
              if (isError() == false) {
                String? cityId = _searchProvider.findCity(_currentCity)?.id;
                String? countryId = _searchProvider.findCountry(_currentCountry)?.id;

                String? transportId;
                if (_transport != null) {
                  transportId = _searchProvider.findTransport(_transport)?.id;
                }

                if (countryId == null && cityId == null) {
                  _webviewProvider.openTechnique(transportId: transportId!, timeEnd: _timeEnd, timeStart: _timeStart);
                } else {
                  _webviewProvider.openLocality(
                      cityId: cityId,
                      countryId: countryId,
                      transportId: transportId,
                      timeStart: _timeStart,
                      timeEnd: _timeEnd);
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Выберите тип или локацию транспорта"),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

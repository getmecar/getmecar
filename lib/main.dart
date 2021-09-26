import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getmecar/components/my_progress_indicator.dart';
import 'package:getmecar/pages/home_page/home_page.dart';
import 'package:getmecar/providers/search_provider.dart';
import 'package:getmecar/providers/webview_provider.dart';
import 'package:getmecar/services/fcm_service.dart';
import 'package:getmecar/services/local_notifications_service.dart';
import 'package:getmecar/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:secondsplash/secondsplash.dart';

void main() async {
  /// init app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationsService.initNotifications();

  /// listen background messages
  FirebaseMessaging.onBackgroundMessage(FCMService.onBackgroundMessageFunction);

  /// listen foreground messages
  FirebaseMessaging.onMessage.listen(FCMService.onForegroundMessageFunction);

  /// get firebase token
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print('TOKEN: $token');
  } catch (e) {
    print('GET TOKEN ERROR: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SearchProvider _searchProvider = SearchProvider();
  final WebviewProvider _webviewProvider = WebviewProvider();
  final SplashController splashController = SplashController();
  bool connected = true;

  Future<void> init() async {
    connected = await checkConnection();
    if (mounted) setState(() {});
    if (connected == false) {
      return;
    }
    await _searchProvider.init();
    await _webviewProvider.init();
  }

  Future<bool> checkConnection() async {
    bool? connected;
    try {
      final result = await InternetAddress.lookup('getmecar.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connected = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      connected = false;
    }
    return (connected ?? false);
  }

  @override
  void initState() {
    super.initState();
    init().whenComplete(() => splashController.close());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WebviewProvider>.value(
          value: _webviewProvider,
        ),
        ChangeNotifierProvider<SearchProvider>.value(value: _searchProvider),
      ],
      child: MaterialApp(
          theme: kLightTheme,
          title: 'GetMeCar',
          home: SecondSplash(
            controller: splashController,
            child: Center(
              child: MyProgressIndicator(),
            ),
            next: connected
                ? HomePage()
                : Scaffold(
                    body: Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await init();
                                  setState(() {});
                                },
                                iconSize: 40,
                                icon: Icon(
                                  Icons.update,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Сеть недоступна, попробуйте позже',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          )),
    );
  }
}

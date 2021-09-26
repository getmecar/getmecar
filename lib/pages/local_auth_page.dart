import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getmecar/components/big_button.dart';
import 'package:getmecar/pages/home_page/home_page.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthPage extends StatefulWidget {
  @override
  _LocalAuthPageState createState() => _LocalAuthPageState();
}

bool? _globalAuthenticated;

class _LocalAuthPageState extends State<LocalAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticating = false;
  bool _isDeviceSupported = true;
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    authenticateIsAvailable();
  }

  Future<void> authenticateIsAvailable() async {
    if (_authenticated == true) {
      return;
    }
    _isDeviceSupported = await auth.isDeviceSupported();
    if (_isDeviceSupported == false) {
      _authenticated = true;
      _globalAuthenticated = true;
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authenticated = false;
      });
      authenticated = await auth.authenticate(localizedReason: 'Авторизация', useErrorDialogs: true, stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authenticated = authenticated;
        if (_authenticated == true) {
          _globalAuthenticated = true;
        }
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        print("Error - ${e.message}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_globalAuthenticated == true) {
      _authenticated = true;
    }
    return Scaffold(
      body: FutureBuilder(
          future: authenticateIsAvailable(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
            if (_authenticated == true) return HomePage();
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 4,
                  ),
                  Image.asset('assets/images/logo.png'),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Авторизируйтесь, чтобы пользоваться приложением',
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(
                    flex: 10,
                  ),
                  BigButton(
                    text: 'Авторизироваться',
                    onTap: () => _authenticate(),
                  )
                ],
              ),
            );
          }),
    );
  }
}

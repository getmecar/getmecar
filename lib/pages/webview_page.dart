import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:getmecar/components/my_progress_indicator.dart';
import 'package:getmecar/providers/webview_provider.dart';
import 'package:getmecar/utils/constants.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'loading_catalog_page.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _TestWebViewPageState createState() => _TestWebViewPageState();
}

class _TestWebViewPageState extends State<WebViewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final InAppReview inAppReview = InAppReview.instance;

  late WebviewProvider _webviewProvider;
  String? currentUrl;
  LoadingState loadingState = LoadingState.ready;

  var _onProgressChanged;
  var _onUrlChanged;
  var _onStateChanged;

  int counter = 0;

  void rateApp() async {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      await inAppReview.openStoreListing();
    }
  }

  @override
  void initState() {
    _onStateChanged = flutterWebviewPlugin.onStateChanged.listen((event) async {
      print('event type: ${event.type}');
      if (event.type != WebViewState.shouldStart) return;

      if (event.url.contains('https://getmecar.ru/wp-login.php?action=logout')) {
        _webviewProvider.userId = null;
        await flutterWebviewPlugin.cleanCookies();
      }

      print('State changed: ${event.url}');
      if (event.url == 'https://getmecar.ru/') {
        _webviewProvider.isCatalog = false;
        Navigator.pop(context);
      }
    });

    /// listen url changing
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print('load url: $url');

      /// if third party url then open browser
      if (url.contains(RegExp(r'[^@]getmecar\.ru')) == false) {
        await flutterWebviewPlugin.stopLoading();
        await launcher
            .launch(url, enableJavaScript: true, forceWebView: false)
            .catchError((e) => print('launcher error: $e'));
        await flutterWebviewPlugin.goBack();
      }
      currentUrl = url;

      /// get cookies
      try {
        var cookies = await flutterWebviewPlugin.getCookies();
        print('COOKIES: $cookies');
        print('webview id : ${cookies[' user_id'] ?? cookies['user_id'] ?? cookies['"user_id']}');
        _webviewProvider.userId = cookies[' user_id'] ?? cookies['user_id'] ?? cookies['"user_id'];
        if (cookies.toString().contains('get_rate: 1') && Constants.appIsRated == false) {
          if (await inAppReview.isAvailable()) {
            await inAppReview.openStoreListing(appStoreId: '');
            Constants.appIsRated = true;
          }
        }
      } catch (e) {
        print('Read Cookies Error: $e');
      }
    });

    /// listen progress changing
    _onProgressChanged = flutterWebviewPlugin.onProgressChanged.listen((event) {
      /// if the site started loading then show loading indicator
      if (event != 1.0 && loadingState == LoadingState.ready) {
        flutterWebviewPlugin.hide();
        loadingState = LoadingState.loading;
      }

      /// if the site finished loading then hide loading indicator
      if (event == 1.0 && loadingState != LoadingState.ready) {
        if (_webviewProvider.isCatalog == false) {
          flutterWebviewPlugin.show();
          loadingState = LoadingState.ready;
        } else {
          _webviewProvider.isCatalog = false;
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _webviewProvider = Provider.of<WebviewProvider>(context);
    if (currentUrl != _webviewProvider.currentUrl) {
      loadUrl();
    }
    currentUrl = _webviewProvider.currentUrl;
    super.didChangeDependencies();
  }

  void loadUrl() async {
    if (currentUrl != null) await flutterWebviewPlugin.launch(currentUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool _canGoBack = await flutterWebviewPlugin.canGoBack();

        if (_canGoBack == true) {
          await flutterWebviewPlugin.goBack();
          await flutterWebviewPlugin.show();
          loadingState = LoadingState.ready;
          _webviewProvider.isCatalog = false;
        } else {
          Navigator.pop(context);
          await flutterWebviewPlugin.stopLoading();
          loadingState = LoadingState.ready;
          _webviewProvider.isCatalog = false;
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.red,
          body: Stack(
            children: [
              WebviewScaffold(
                bottomNavigationBar: null,
                appCacheEnabled: true,
                clearCache: false,
                withLocalUrl: true,
                url: currentUrl!,
                withJavascript: true,
                allowFileURLs: true,
                withLocalStorage: true,
              ),
              MyProgressIndicator(),
              if (_webviewProvider.isCatalog) LoadingCatalogPage(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _onProgressChanged.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cansel();
    flutterWebviewPlugin.dispose();

    super.dispose();
  }
}

enum LoadingState { loading, ready }

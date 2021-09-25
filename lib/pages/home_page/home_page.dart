import 'package:flutter/material.dart';
import 'package:get_me_car/components/outlined_button.dart';
import 'package:get_me_car/pages/home_page/technique_search.dart';
import 'package:get_me_car/pages/webview_page.dart';
import 'package:get_me_car/providers/webview_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  late WebviewProvider _webviewProvider;

  @override
  Widget build(BuildContext context) {
    _webviewProvider = Provider.of<WebviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset('assets/images/logo.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () => launch('tel:+79539990013'),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage()));
              _webviewProvider.openLogin();
            },
          ),
          const SizedBox(
            width: 10,
          ),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 1:
                  print('1');
                  break;
                case 2:
                  _webviewProvider.openFaq();
                  break;
                case 3:
                  _webviewProvider.openRegistrationHelp();
                  break;
                case 4:
                  _webviewProvider.openContacts();
                  break;
                case 5:
                  _webviewProvider.openAddTechnique();
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage()));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Вопрос-ответ"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Помощь в регистрации"),
                value: 3,
              ),
              PopupMenuItem(
                child: Text("Контакты"),
                value: 4,
              ),
              PopupMenuItem(
                value: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "Добавить ТС",
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0.5,
                          offset: Offset(0, 1),
                          blurRadius: 0.25),
                    ],
                  ),
                ),
              ),
            ],
            child: Icon(Icons.menu),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
        elevation: 0,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Аренда техники от собственников',
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Без скрытых платежей\n15 стран и 5000 единиц техники\nБесплатная отмена бронирования',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              TechniqueSearch(),
              Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: MyOutlinedButton(
                  text: 'Добавить технику',
                  prefix: Icons.add,
                  onTap: () {
                    _webviewProvider.openAddTechnique();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

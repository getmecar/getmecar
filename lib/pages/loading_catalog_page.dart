import 'package:flutter/material.dart';
import 'package:get_me_car/components/my_progress_indicator.dart';

class LoadingCatalogPage extends StatelessWidget {
  const LoadingCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyProgressIndicator(),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Пожалуйста, подождите...\nВ данный момент мы ищем лучше предложения среди 200 владельцев техники',
            style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

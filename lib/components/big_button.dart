import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  const BigButton({Key? key, required this.text, this.onTap}) : super(key: key);

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
      child: InkWell(
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

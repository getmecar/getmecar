import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({Key? key, required this.text, this.prefix, this.onTap}) : super(key: key);

  final String text;
  final IconData? prefix;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 3, color: Colors.white)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              prefix,
              color: Colors.white,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

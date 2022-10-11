import 'package:flutter/material.dart';

class Headline1 extends StatelessWidget {
  final String text;

  const Headline1({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Login'.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
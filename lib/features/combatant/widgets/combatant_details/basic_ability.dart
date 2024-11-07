import 'package:flutter/material.dart';

class BasicAbility extends StatelessWidget {
  const BasicAbility({
    super.key,
    required this.boldText,
    required this.text,
    this.color = Colors.black,
  });

  final String boldText;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

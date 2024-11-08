import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:markdown/markdown.dart' as md;

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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Text(
          boldText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        HtmlWidget(
          md.markdownToHtml(text).replaceAll("<p>", "").replaceAll("</p>", ""),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:markdown/markdown.dart' as md;

class BasicAbility extends StatelessWidget {
  const BasicAbility({
    super.key,
    required this.boldText,
    this.htmlText,
    this.text,
    this.color = Colors.black,
  }) : assert(htmlText != null || text != null);

  final String boldText;
  final String? htmlText;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (htmlText == null) {
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
            if (text != null)
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

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      children: [
        Text(
          boldText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (htmlText != null)
          HtmlWidget(
            md
                .markdownToHtml(htmlText!)
                .replaceAll("<p>", "")
                .replaceAll("</p>", ""),
          ),
      ],
    );
  }
}

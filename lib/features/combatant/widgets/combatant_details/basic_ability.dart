import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battlemaster/common/fonts/action_font.dart';
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
    this.actions = const [],
  }) : assert(htmlText != null || text != null);

  final String boldText;
  final String? htmlText;
  final String? text;
  final Color? color;
  final List<ActionsEnum> actions;

  @override
  Widget build(BuildContext context) {
    if (htmlText == null) {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: boldText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (actions.isNotEmpty) _getActionSpan(context),
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
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: boldText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (actions.isNotEmpty) _getActionSpan(context),
            ],
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

  TextSpan _getActionSpan(BuildContext context) {
    if (actions.length == 1) {
      return TextSpan(
        text: actions.first.toActionString(),
        style: const TextStyle(fontFamily: "ActionIcons"),
      );
    }

    final localization = AppLocalizations.of(context)!;

    final text = actions
        .map((action) => action.toActionString())
        .join(" ${localization.pf2e_variable_action_preposition} ");
    return TextSpan(
      text: text,
      style: const TextStyle(fontFamily: "ActionIcons"),
    );
  }
}

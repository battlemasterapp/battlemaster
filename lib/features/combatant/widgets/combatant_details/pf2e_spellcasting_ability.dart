import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_spellcasting.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:battlemaster/features/combatant/widgets/traits.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Pf2eSpellcastingAbility extends StatelessWidget {
  const Pf2eSpellcastingAbility(
    this.spellcasting, {
    super.key,
  });

  final Pf2eSpellcasting spellcasting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: [spellcasting.name].whereType<String>().join(" "),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " "),
              TextSpan(text: "DC ${spellcasting.dc}; "),
              if (spellcasting.attack != null)
                TextSpan(text: "attack ${spellcasting.attack?.signString}; "),
            ],
          ),
        ),
        if (spellcasting.cantrips != null)
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: getCantrips(context),
            ),
          ),
        for (final spellLevel
            in spellcasting.spells ?? <SpellcastingLevelEntry>[]) ...[
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: getSpells(
                context,
                spellLevel,
                spellLevel.level.ordinal,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<TextSpan> getCantrips(BuildContext context) {
    if (spellcasting.cantrips == null) {
      return [];
    }

    return getSpells(
      context,
      spellcasting.cantrips!,
      "Cantrips (${spellcasting.cantrips!.level.ordinal})",
    );
  }

  List<TextSpan> getSpells(
      BuildContext context, SpellcastingLevelEntry spellLevel, String title) {
    return [
      TextSpan(
        text: "$title ",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      if (spellLevel.slots != null)
        TextSpan(text: "(${spellLevel.slots} slots) "),
      for (final spell in spellLevel.spells) ...[
        _getSpell(context, spell),
        TextSpan(text: '; '),
      ],
    ];
  }
}

TextSpan _getSpell(BuildContext context, Pf2eSpellEntry spell) {
  final onTap = TapGestureRecognizer()
    ..onTap = () {
      showDialog(
        context: context,
        builder: (context) => _SpellInfoDialog(spell),
      );
    };

  String name = spell.name;
  final amount = spell.amount;
  name = "$name${amount != null ? " (x$amount)" : ""}";
  return TextSpan(
    text: name,
    recognizer: onTap,
    style: const TextStyle(decoration: TextDecoration.underline),
  );
}

class _SpellInfoDialog extends StatelessWidget {
  const _SpellInfoDialog(this.spell);

  final Pf2eSpellEntry spell;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  spell.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  "${spell.isCantrip ? "Cantrip" : "Spell"} ${spell.level}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Traits(traits: spell.traits),
            BasicAbility(
              boldText: "Traditions: ",
              text: spell.traditions.join(", ").capitalizeAll(),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            BasicAbility(
              boldText: "Cast ",
              actions: spell.actions,
              text: "",
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            if (spell.range.isNotEmpty)
              BasicAbility(
                boldText: "Range ",
                text: spell.range,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            Row(
              children: [
                if (spell.area != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: BasicAbility(
                      boldText: "Area ",
                      text: spell.area,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                if (spell.targets.isNotEmpty)
                  BasicAbility(
                    boldText: "Targets ",
                    text: spell.targets,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
              ],
            ),
            if (spell.defense.isNotEmpty)
              BasicAbility(
                boldText: "Defense ",
                text: spell.isBasicSave
                    ? 'Basic ${spell.defense}'
                    : spell.defense,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            if (spell.duration.isNotEmpty || spell.isSustained)
              BasicAbility(
                boldText: "Duration ",
                text: spell.isSustained
                    ? '${spell.duration} Sustained'
                    : spell.duration,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            const Divider(),
            HtmlWidget(spell.description),
          ],
        ),
      ),
    );
  }
}

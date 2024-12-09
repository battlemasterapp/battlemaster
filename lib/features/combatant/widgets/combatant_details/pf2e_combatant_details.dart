import 'package:battlemaster/common/fonts/action_font.dart';
import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/extensions/list_extensions.dart';
import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_attack.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/pf2e_spellcasting_ability.dart';
import 'package:battlemaster/features/combatant/widgets/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:icons_plus/icons_plus.dart';

class Pf2eCombatantDetails extends StatelessWidget {
  const Pf2eCombatantDetails({
    super.key,
    required this.combatant,
  });

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Traits(traits: combatant.traits),
        Text(
          localization.pf2e_creature_level(combatant.level),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black.withOpacity(0.8),
              ),
        ),
        const SizedBox(height: 12),
        _Perception(combatant),
        if (combatant.languages.isNotEmpty) ...[
          const SizedBox(height: 8),
          BasicAbility(
            boldText: "${localization.dnd5e_languages} ",
            text:
                "${combatant.languages.join(', ').capitalizeAll()} ${combatant.languageDetails}",
          ),
        ],
        if (combatant.skills.isNotEmpty) ...[
          const SizedBox(height: 8),
          BasicAbility(
            boldText: "${localization.dnd5e_skills} ",
            text: combatant.skills.join(', ').capitalizeAll(),
          ),
        ],
        const SizedBox(height: 8),
        _Attributes(combatant),
        if (combatant.items.isNotEmpty) ...[
          const SizedBox(height: 8),
          BasicAbility(
            boldText: '${localization.pf2e_items} ',
            text: combatant.items.join(', '),
          ),
        ],
        if (combatant.topAbilities.isNotEmpty) ...[
          const SizedBox(height: 8),
          _SpecialAbilities(combatant.topAbilities),
        ],
        const Divider(),
        _Defenses(combatant),
        const SizedBox(height: 8),
        _Health(combatant),
        if (combatant.midAbilities.isNotEmpty) ...[
          const SizedBox(height: 8),
          _SpecialAbilities(combatant.midAbilities),
        ],
        const Divider(),
        _Speed(combatant),
        const SizedBox(height: 8),
        _Attacks(combatant),
        if (combatant.spellcasting.isNotEmpty) ...[
          const SizedBox(height: 8),
          _Spells(combatant),
        ],
        if (combatant.botAbilities.isNotEmpty) ...[
          const SizedBox(height: 8),
          _SpecialAbilities(combatant.botAbilities),
        ],
        const Divider(),
        _RecallKnowledge(combatant),
      ],
    );
  }
}

class _Perception extends StatelessWidget {
  const _Perception(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final otherSenses = combatant.otherSenses;
    if (otherSenses.isNotEmpty) {
      return BasicAbility(
        boldText: '${localization.pf2e_perception} ',
        text: '${combatant.perception.signString}, ${otherSenses.join(', ')}',
      );
    }
    return BasicAbility(
      boldText: localization.pf2e_perception,
      text: combatant.perception.signString,
    );
  }
}

class _Attributes extends StatelessWidget {
  const _Attributes(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final attributes = {
      localization.str_short: combatant.strength,
      localization.dex_short: combatant.dexterity,
      localization.con_short: combatant.constitution,
      localization.int_short: combatant.intelligence,
      localization.wis_short: combatant.wisdom,
      localization.cha_short: combatant.charisma,
    };
    return Wrap(
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      direction: Axis.horizontal,
      children: [
        for (final entry in attributes.entries) ...[
          Text(
            entry.key.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(entry.value.modifier.signString),
        ],
      ],
    );
  }
}

class _Defenses extends StatelessWidget {
  const _Defenses(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    String acString = combatant.ac.toString();
    if (combatant.acDetails.isNotEmpty) {
      acString += " ${combatant.acDetails}";
    }
    return Wrap(
      children: [
        BasicAbility(
          boldText: '${localization.pf2e_ac} ',
          text: acString,
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: '${localization.pf2e_fort} ',
          text: combatant.fortitude.signString,
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: '${localization.pf2e_ref} ',
          text: combatant.reflex.signString,
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: '${localization.pf2e_will} ',
          text: combatant.will.signString,
        ),
      ],
    );
  }
}

class _Health extends StatelessWidget {
  const _Health(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final hpDetails =
        combatant.hpDetails.isNotEmpty ? " (${combatant.hpDetails})" : "";
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '${localization.pf2e_hp} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '${combatant.hp}$hpDetails;'),
          if (combatant.hardness != null) ...[
            TextSpan(
              text: ' ${localization.pf2e_hardness} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '${combatant.hardness};'),
          ],
          if (combatant.immunities.isNotEmpty) ...[
            TextSpan(
              text: ' ${localization.pf2e_immunities} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "${(combatant.immunities..sort()).join(', ')};",
            ),
          ],
          if (combatant.resistances.isNotEmpty) ...[
            TextSpan(
              text: ' ${localization.pf2e_resistances} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "${combatant.resistances.join(', ')};",
            ),
          ],
          if (combatant.weaknesses.isNotEmpty) ...[
            TextSpan(
              text: ' ${localization.pf2e_weaknesses} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "${combatant.weaknesses.join(', ')};",
            ),
          ],
        ],
      ),
    );
  }
}

class _Speed extends StatelessWidget {
  const _Speed(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final otherSpeeds = combatant.otherSpeeds.isEmpty
        ? ""
        : ", ${combatant.otherSpeeds.join(', ')}";
    return BasicAbility(
      boldText: '${localization.speed_label} ',
      text: "${combatant.baseSpeed} feet$otherSpeeds",
    );
  }
}

class _Attacks extends StatelessWidget {
  const _Attacks(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.attacks.isEmpty) {
      return const SizedBox.shrink();
    }
    final List<Widget> children = combatant.attacks
        .map((a) => _Attack(a))
        .toList()
        .cast<Widget>()
        .intercalate(const SizedBox(height: 8));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _Attack extends StatelessWidget {
  const _Attack(this.attack);

  final Pf2eAttack attack;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "${attack.range.capitalize()} ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          getAction(),
          TextSpan(text: "${attack.name} "),
          TextSpan(text: "${attack.modifier.signString} "),
          TextSpan(text: "[${attack.map.map((i) => i.signString).join("/")}] "),
          if (attack.traits.isNotEmpty)
            TextSpan(
                text:
                    "(${attack.traits.join(", ").capitalizeAll().replaceAll("-", " ")}) "),
          if (attack.damage != null) ...[
            TextSpan(
              text: "${localization.pf2e_damage} ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "${attack.damage} "),
          ],
          if (attack.effects.isNotEmpty) ...[
            TextSpan(
              text: "${localization.pf2e_effects} ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
                text: attack.effects
                    .join(", ")
                    .replaceAll("-", " ")
                    .capitalizeAll()),
          ],
        ],
      ),
    );
  }

  TextSpan getAction() {
    return TextSpan(
      text: "${actionToString(ActionsEnum.one)} ",
      style: const TextStyle(fontFamily: "ActionIcons"),
    );
  }
}

class _RecallKnowledge extends StatelessWidget {
  const _RecallKnowledge(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BasicAbility(
          boldText:
              "Recall Knowledge (${combatant.recallKnowledge.skills.join(', ')}): ",
          text: "DC ${combatant.recallKnowledge.dc}",
        ),
        BasicAbility(
          boldText: "Unspecific Lore: ",
          text: "${combatant.recallKnowledge.unspecificDC}",
        ),
        BasicAbility(
          boldText: "Specific Lore: ",
          text: "${combatant.recallKnowledge.specificDC}",
        ),
      ],
    );
  }
}

class _SpecialAbilities extends StatelessWidget {
  const _SpecialAbilities(this.abilities);

  final List<Pf2eSpecialAbility> abilities;

  @override
  Widget build(BuildContext context) {
    if (abilities.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final ability in abilities) _SpecialAbility(ability),
      ],
    );
  }
}

class _SpecialAbility extends StatefulWidget {
  const _SpecialAbility(this.ability);

  final Pf2eSpecialAbility ability;

  @override
  State<_SpecialAbility> createState() => _SpecialAbilityState();
}

class _SpecialAbilityState extends State<_SpecialAbility> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() {
            _expanded = !_expanded;
          }),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      widget.ability.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (widget.ability.actions.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      getAction(),
                    ],
                    if (widget.ability.traits.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        "(${widget.ability.traits.join(", ").replaceAll("-", " ")})",
                      ),
                    ],
                  ],
                ),
              ),
              if (_expanded)
                const Icon(
                  MingCute.up_fill,
                  color: Colors.black,
                ),
              if (!_expanded)
                const Icon(
                  MingCute.down_fill,
                  color: Colors.black,
                ),
            ],
          ),
        ),
        if (_expanded) HtmlWidget(widget.ability.description),
      ],
    );
  }

  Widget getAction() {
    return Text(
      widget.ability.actions.map((a) => a.toActionString()).join(" "),
      style: const TextStyle(fontFamily: "ActionIcons"),
    );
  }
}

class _Spells extends StatelessWidget {
  const _Spells(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = combatant.spellcasting
        .map((tradition) => Pf2eSpellcastingAbility(tradition))
        .toList()
        .cast<Widget>()
        .intercalate(const SizedBox(height: 8));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...children,
        // TODO: rituals
      ],
    );
  }
}

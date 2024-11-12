import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dnd5eCombatantDetails extends StatelessWidget {
  const Dnd5eCombatantDetails({
    super.key,
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CombatantType(combatant: combatant),
        const Divider(),
        _ArmorClass(combatant: combatant),
        BasicAbility(
          boldText: '${localization.hit_points} ',
          text: combatant.hp.toString(),
        ),
        _CombatantSpeed(combatant: combatant),
        const Divider(),
        _CombatantAttributes(combatant: combatant),
        const Divider(),
        _CombatantSaves(combatant: combatant),
        _CombatantSkill(combatant: combatant),
        if (combatant.damageVulnerabilities.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_damage_vulnerabilities} ",
            text: combatant.damageVulnerabilities,
          ),
        if (combatant.damageResistances.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_damage_resistances} ",
            text: combatant.damageResistances,
          ),
        if (combatant.damageImmunities.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_damage_immunities} ",
            text: combatant.damageImmunities,
          ),
        if (combatant.conditionImmunities.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_condition_immunities} ",
            text: combatant.conditionImmunities,
          ),
        if (combatant.senses.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_senses} ",
            text: combatant.senses,
          ),
        if (combatant.languages.isNotEmpty)
          BasicAbility(
            boldText: "${localization.dnd5e_languages} ",
            text: combatant.languages,
          ),
        const Divider(),
        _CombatantAbility(
          abilities: combatant.specialAbilities,
        ),
        _CombatantAbility(
          abilities: combatant.actions,
          title: localization.dnd5e_actions,
        ),
        _CombatantAbility(
          abilities: combatant.legendaryActions,
          title: localization.dnd5e_legendary_actions,
          description: combatant.legendaryDescription,
        ),
      ],
    );
  }
}

class _ArmorClass extends StatelessWidget {
  const _ArmorClass({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final armorDescription = combatant.armorDescription;

    var text = combatant.ac.toString();

    if (armorDescription.isNotEmpty) {
      text += " ($armorDescription)";
    }

    return BasicAbility(
      boldText: "${localization.armor_class} ",
      text: text,
    );
  }
}

class _CombatantType extends StatelessWidget {
  const _CombatantType({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final texts = [
      combatant.size,
      combatant.type,
      if (combatant.subtype.isNotEmpty) "(${combatant.subtype})",
    ].nonNulls.toList().join(" ");
    return Text("$texts, ${combatant.alignment}");
  }
}

class _CombatantSpeed extends StatelessWidget {
  const _CombatantSpeed({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final baseSpeed = combatant.speed.walk;
    final speeds = [
      localization.speed_ft(baseSpeed),
      if (combatant.speed.fly > 0)
        localization.fly_speed_ft(combatant.speed.fly),
      if (combatant.speed.swim > 0)
        localization.swim_speed_ft(combatant.speed.swim),
      if (combatant.speed.burrow > 0)
        localization.burrow_speed_ft(combatant.speed.burrow),
      if (combatant.speed.climb > 0)
        localization.climb_speed_ft(combatant.speed.climb),
    ].join(", ");
    return BasicAbility(boldText: '${localization.speed_label} ', text: speeds);
  }
}

class _CombatantSaves extends StatelessWidget {
  const _CombatantSaves({required this.combatant});

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final saves = {
      localization.str_short: combatant.strengthSave,
      localization.dex_short: combatant.dexteritySave,
      localization.con_short: combatant.constitutionSave,
      localization.int_short: combatant.intelligenceSave,
      localization.wis_short: combatant.wisdomSave,
      localization.cha_short: combatant.charismaSave,
    }..removeWhere((_, value) => value == null);
    if (saves.isEmpty) {
      return Container();
    }
    return BasicAbility(
        boldText: "${localization.dnd5e_saving_throws} ",
        text: saves.entries
            .map((e) => "${e.key} ${e.value!.signString}")
            .join(", "));
  }
}

class _CombatantSkill extends StatelessWidget {
  const _CombatantSkill({required this.combatant});

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localzation = AppLocalizations.of(context)!;
    final skills = combatant.skills;
    if (skills.isEmpty) {
      return Container();
    }
    return BasicAbility(
      boldText: "${localzation.dnd5e_skills} ",
      text: skills
          .map((skill) => "${skill.name} ${skill.modifier.signString}")
          .join(", "),
    );
  }
}

class _CombatantAttributes extends StatelessWidget {
  const _CombatantAttributes({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final entry in attributes.entries)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "${entry.value.attribute} (${entry.value.modifier.signString})"),
              ],
            ),
          ),
      ],
    );
  }
}

class _CombatantAbility extends StatelessWidget {
  const _CombatantAbility({
    required this.abilities,
    this.title,
    this.description,
  });

  final List<Dnd5eAbility> abilities;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (abilities.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black),
          ),
        if (description != null) Text(description!),
        for (final ability in abilities)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: BasicAbility(
              boldText: "${ability.name} ",
              text: ability.desc,
            ),
          ),
        const Divider(),
      ],
    );
  }
}

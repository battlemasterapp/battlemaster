import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../engines/models/game_engine_type.dart';
import '../models/combatant.dart';
import '../models/combatant_type.dart';

class AddCustomCombatant extends StatefulWidget {
  const AddCustomCombatant({
    super.key,
    this.onCombatantAdded,
  });

  final ValueChanged<Combatant>? onCombatantAdded;

  @override
  State<AddCustomCombatant> createState() => _AddCustomCombatantState();
}

class _AddCustomCombatantState extends State<AddCustomCombatant> {
  final _formKey = GlobalKey<FormState>();
  late Combatant combatant;

  @override
  void initState() {
    super.initState();
    combatant = _getBaseCombatant();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name_label),
                  onChanged: (value) {
                    combatant = combatant.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.name_validation_text;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final hp = int.tryParse(value);
                    combatant = combatant.copyWith(
                      maxHp: hp,
                      currentHp: hp,
                    );
                  },
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.hp_label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    combatant =
                        combatant.copyWith(armorClass: int.tryParse(value));
                  },
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.ac_label),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    combatant = combatant.copyWith(
                      initiativeModifier: int.tryParse(value),
                    );
                  },
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .initiative_modifier_label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButton<CombatantType>(
            hint: Text(
                AppLocalizations.of(context)!.combatant_type_dropdown_label),
            value: combatant.type,
            onChanged: (value) {
              setState(() {
                combatant = combatant.copyWith(type: value);
              });
            },
            items: CombatantType.values.map(
              (type) {
                final localization = AppLocalizations.of(context)!;
                final typeNames = {
                  CombatantType.monster: localization.combatant_type_monster,
                  CombatantType.player: localization.combatant_type_player,
                  CombatantType.hazard: localization.combatant_type_hazard,
                  CombatantType.lair: localization.combatant_type_lair,
                };
                return DropdownMenuItem(
                  value: type,
                  child: Text(typeNames[type]!),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  widget.onCombatantAdded?.call(combatant);
                  _formKey.currentState!.reset();
                  combatant = _getBaseCombatant();
                },
                child:
                    Text(AppLocalizations.of(context)!.add_combatants_button),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Combatant _getBaseCombatant() {
    return Combatant(
      name: '',
      currentHp: 0,
      maxHp: 0,
      armorClass: 0,
      initiativeModifier: 0,
      type: CombatantType.monster,
      engineType: GameEngineType.pf2e,
    );
  }
}

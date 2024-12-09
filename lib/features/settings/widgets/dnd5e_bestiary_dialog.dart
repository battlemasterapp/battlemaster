import 'package:battlemaster/features/settings/providers/dnd5e_bestiary_source.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Dnd5eBestiaryDialog extends StatelessWidget {
  const Dnd5eBestiaryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Dnd5eBestiarySource>(
      create: (_) => Dnd5eBestiarySource(),
      child: const _Dialog(),
    );
  }
}

class _Dialog extends StatefulWidget {
  const _Dialog();

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  final _selected = <String>{};

  @override
  void initState() {
    super.initState();
    final selectedBestiaries =
        context.read<SystemSettingsProvider>().dnd5eSettings.sources;
    _selected.addAll(selectedBestiaries);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final state = context.watch<Dnd5eBestiarySource>();
    return AlertDialog(
      title: Text(localization.select_bestiaries_title),
      content: SizedBox(
        width: 500,
        child: state.status == Dnd5eBestiarySourceStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (final bestiary in state.bestiaries.entries.toList())
                      CheckboxListTile(
                        value: _selected.contains(bestiary.key),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selected.add(bestiary.key);
                            } else {
                              _selected.remove(bestiary.key);
                            }
                          });
                        },
                        title: Text(
                          bestiary.value['title']!,
                        ),
                        subtitle: Text(
                          bestiary.value['desc']!,
                        ),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            context.pop();
          },
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            context.pop(_selected);
          },
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}

import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/settings/providers/pf2e_bestiary_source.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Pf2eBestiaryDialog extends StatelessWidget {
  const Pf2eBestiaryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Pf2eBestiarySource>(
      create: (_) => Pf2eBestiarySource(),
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
        context.read<SystemSettingsProvider>().pf2eSettings.bestiaries;
    _selected.addAll(selectedBestiaries);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final state = context.watch<Pf2eBestiarySource>();
    return AlertDialog(
      title: Text(localization.select_bestiaries_title),
      content: SizedBox(
        width: 500,
        child: state.status == Pf2eBestiarySourceStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (final bestiary in state.bestiaries.toList()..sort())
                      CheckboxListTile(
                        value: _selected.contains(bestiary),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selected.add(bestiary);
                            } else {
                              _selected.remove(bestiary);
                            }
                          });
                        },
                        title: Text(
                          bestiary
                              .split('-')
                              .map((s) => s.capitalize())
                              .join(' '),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_selected);
          },
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}

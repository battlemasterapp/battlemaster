import 'dart:io';

import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:battlemaster/features/settings/models/custom_bestiary_file.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

typedef BestiarySelectedCallback = void Function(
    CustomBestiaryFile customBestiaryFile);

class ImportBestiaryDialog extends StatefulWidget {
  const ImportBestiaryDialog({
    super.key,
    required this.onFileSelected,
  });

  final BestiarySelectedCallback onFileSelected;

  @override
  State<ImportBestiaryDialog> createState() => _ImportBestiaryDialogState();
}

class _ImportBestiaryDialogState extends State<ImportBestiaryDialog> {
  GameEngineType _engine = GameEngineType.custom;
  String _name = '';
  File? _file = null;
  Uint8List? _bytes = null;
  String _fileName = '';

  bool get canImport {
    return _name.isNotEmpty && _fileName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final settings = context.watch<SystemSettingsProvider>();
    // FIXME: textos
    return AlertDialog(
      title: Text("Importar bestiário personalizado"),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecione um arquivo CSV para importar'),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sistema do jogo:'),
                  const SizedBox(width: 8),
                  DropdownButton<GameEngineType>(
                    value: _engine,
                    onChanged: (value) {
                      setState(() {
                        _engine = value!;
                      });
                    },
                    items: GameEngineType.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.translate(localization)),
                            ))
                        .where((e) {
                      final excludeList = [
                        if (!settings.pf2eSettings.enabled) GameEngineType.pf2e,
                        if (!settings.dnd5eSettings.enabled)
                          GameEngineType.dnd5e,
                      ];

                      return !excludeList.contains(e.value);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (_fileName.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(_fileName),
                    ),
                    const Spacer(),
                  ],
                  ElevatedButton(
                    onPressed: () async {
                      final file = await FilePicker.platform.pickFiles(
                        allowedExtensions: ['csv'],
                        type: FileType.custom,
                      );
                      if (file == null) {
                        return;
                      }
                      setState(() {
                        _fileName = file.files.single.name;
                        if (kIsWeb) {
                          _bytes = file.files.single.bytes;
                        } else {
                          _file = File(file.files.single.path!);
                        }
                      });
                    },
                    child: Text('Selecionar arquivo'),
                  ),
                ],
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
          onPressed: canImport
              ? () {
                  widget.onFileSelected(
                    CustomBestiaryFile(
                      name: _name,
                      file: _file,
                      bytes: _bytes,
                      engine: _engine,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              : null,
          // FIXME: change to import button
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:battlemaster/features/settings/models/custom_bestiary_file.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
  File? _file;
  Uint8List? _bytes;
  String _fileName = '';

  bool get canImport {
    return _name.isNotEmpty && _fileName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final settings = context.read<SystemSettingsProvider>();
    return AlertDialog(
      title: Text(localization.import_bestiary_dialog_title),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.import_bestiary_dialog_description(
                  CustomBestiaryFile.fileExtensions[_engine]!.toUpperCase(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: localization.name_label),
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
                  Text('${localization.game_system_label}:'),
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
                      // TODO: Remove this when we have support for more engines
                      final excludeList = [
                        GameEngineType.pf2e,
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
                        allowedExtensions: [
                          CustomBestiaryFile.fileExtensions[_engine]!
                        ],
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
                    child: Text(
                      localization.choose_file_type_button(
                        CustomBestiaryFile.fileExtensions[_engine]!
                            .toUpperCase(),
                      ),
                    ),
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
            context.pop();
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
                  context.pop();
                }
              : null,
          child: Text(localization.import_button),
        ),
      ],
    );
  }
}

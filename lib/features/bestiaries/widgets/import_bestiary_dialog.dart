import 'dart:io';

import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:battlemaster/features/settings/models/custom_bestiary_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String _path = '';

  bool get canImport {
    return _name.isNotEmpty && _path.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
                              child: Text(e.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if(_path.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(_path),
                  ),
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
                        _path = file.files.single.path!;
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
                      file: File(_path),
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

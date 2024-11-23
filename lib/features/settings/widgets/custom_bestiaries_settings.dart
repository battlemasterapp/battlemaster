import 'package:battlemaster/features/bestiaries/providers/custom_bestiary_provider.dart';
import 'package:battlemaster/features/bestiaries/widgets/import_bestiary_dialog.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class CustomBestiariesSettings extends StatelessWidget {
  const CustomBestiariesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return Column(
      children: [
        ListTile(
          title: Text(
            'Bestiários personalizados',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListTile(
          leading: Icon(MingCute.file_new_fill),
          title: Text('Importar bestiário'),
          trailing: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => ImportBestiaryDialog(
                  onFileSelected: (bestiaryFile) async {
                    await context
                        .read<CustomBestiaryProvider>()
                        .create(bestiaryFile);
                  },
                ),
              );
            },
            child: Text('Importar'),
          ),
        ),
        const Divider(),
        ListTile(
          title: Text('Meus bestiários'),
        ),
      ],
    );
  }
}

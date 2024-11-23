import 'package:battlemaster/features/bestiaries/models/custom_bestiary.dart';
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
          subtitle: Text('Importe um arquivo CSV com os combatentes'),
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
        ListTile(
          leading: Icon(MingCute.file_download_fill),
          title: Text('Baixar modelos'),
          subtitle: Text('Baixe os modelos CSV para criar seus bestiários'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: Text('Baixar'),
          ),
        ),
        const Divider(),
        ListTile(
          leading: Icon(MingCute.book_5_fill),
          title: Text('Meus bestiários'),
        ),
        StreamBuilder<List<CustomBestiary>>(
            stream: context.read<CustomBestiaryProvider>().watchAll(),
            builder: (context, snapshot) {
              final bestiaries = snapshot.data ?? [];
              return ListView.builder(
                shrinkWrap: true,
                itemCount: bestiaries.length,
                itemBuilder: (context, index) {
                  final bestiary = bestiaries[index];
                  return Card(
                    child: ListTile(
                      title: Text(bestiary.name),
                      subtitle: Text(
                          '${bestiary.combatants.length} combatentes\n${bestiary.engine}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(MingCute.delete_2_fill),
                        onPressed: () async {
                          await context
                              .read<CustomBestiaryProvider>()
                              .delete(bestiary);
                        },
                      ),
                    ),
                  );
                },
              );
            })
      ],
    );
  }
}

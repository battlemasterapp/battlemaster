import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/conditions/providers/conditions_provider.dart';
import 'package:battlemaster/features/conditions/widgets/create_condition_dialog.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class CustomConditionsPage extends StatelessWidget {
  const CustomConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIXME: textos
      appBar: AppBar(
        title: Text('Custom Conditions'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MingCute.add_fill),
        onPressed: () async {
          // TODO: open dialog to add new condition
          final condition = await showDialog<CustomCondition?>(
            context: context,
            builder: (context) => const CreateConditionDialog(),
          );

          if (condition == null) {
            return;
          }

          // ignore: use_build_context_synchronously
          await context.read<ConditionsProvider>().addCondition(condition);
        },
      ),
      body: SafeArea(
        child: StreamBuilder<List<CustomCondition>>(
            stream: context.read<ConditionsProvider>().watchConditions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final conditions = snapshot.data ?? [];

              if (conditions.isEmpty) {
                return Center(
                  child: Text('No custom conditions'),
                );
              }

              return ListView.separated(
                itemCount: conditions.length,
                padding: const EdgeInsets.only(bottom: 60),
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final condition = conditions[index];
                  return ListTile(
                    title: Text(condition.name),
                    subtitle: Text(condition.description),
                    trailing: IconButton(
                      icon: Icon(MingCute.delete_2_fill),
                      onPressed: () async {
                        await context
                            .read<ConditionsProvider>()
                            .deleteCondition(condition);
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

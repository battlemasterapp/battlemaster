import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/conditions/providers/conditions_provider.dart';
import 'package:battlemaster/features/conditions/widgets/create_condition_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class CustomConditionsPage extends StatelessWidget {
  const CustomConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final conditionsProvider = context.read<ConditionsProvider>();
    final analyticsService = context.read<AnalyticsService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.custom_conditions_title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MingCute.add_fill),
        onPressed: () async {
          final condition = await showDialog<CustomCondition?>(
            context: context,
            builder: (context) => const CreateConditionDialog(),
          );

          if (condition == null) {
            return;
          }

          await conditionsProvider.addCondition(condition);
          await analyticsService.logEvent('condition_created');
        },
      ),
      body: SafeArea(
        child: StreamBuilder<List<CustomCondition>>(
            stream: conditionsProvider.watchConditions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final conditions = snapshot.data ?? [];

              if (conditions.isEmpty) {
                return Center(
                  child: Text(localization.custom_conditions_empty_list),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.separated(
                    itemCount: conditions.length,
                    padding: const EdgeInsets.only(bottom: 80, top: 8),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final condition = conditions[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(condition.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const Divider(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(condition.description)),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: Icon(MingCute.delete_2_fill),
                                      onPressed: () async {
                                        await conditionsProvider
                                            .deleteCondition(condition);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}

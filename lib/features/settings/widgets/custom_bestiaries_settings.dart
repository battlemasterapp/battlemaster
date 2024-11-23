import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/bestiaries/models/custom_bestiary.dart';
import 'package:battlemaster/features/bestiaries/providers/custom_bestiary_provider.dart';
import 'package:battlemaster/features/bestiaries/widgets/import_bestiary_dialog.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CustomBestiariesSettings extends StatelessWidget {
  const CustomBestiariesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final analytics = context.read<AnalyticsService>();
    return Column(
      children: [
        ListTile(
          title: Text(
            localization.settings_tab_custom_bestiaries,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListTile(
          leading: Icon(MingCute.file_new_fill),
          title: Text(localization.import_bestiary_dialog_title),
          subtitle: Text(localization.import_bestiary_subtitle),
          trailing: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => ImportBestiaryDialog(
                  onFileSelected: (bestiaryFile) async {
                    try {
                      await context
                          .read<CustomBestiaryProvider>()
                          .create(bestiaryFile);
                      analytics.logEvent(
                        'bestiary_imported',
                        props: {'engine': bestiaryFile.engine.toString()},
                      );
                      toastification.show(
                        type: ToastificationType.success,
                        style: ToastificationStyle.fillColored,
                        showProgressBar: false,
                        autoCloseDuration: 5.seconds,
                        title: Text(localization.bestiary_import_success),
                      );
                    } on Exception catch (e) {
                      Logger().e(e);
                      toastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.fillColored,
                        showProgressBar: false,
                        autoCloseDuration: 5.seconds,
                        title: Text(localization.bestiary_import_fail),
                        description: Text(
                          localization.bestiary_import_fail_description,
                        ),
                      );
                    }
                  },
                ),
              );
            },
            child: Text(localization.import_button),
          ),
        ),
        ListTile(
          leading: Icon(MingCute.file_download_fill),
          title: Text(localization.download_bestiary_models_title),
          subtitle: Text(localization.download_bestiary_models_subtitle),
          trailing: _DownloadTemplateButton(analytics: analytics),
        ),
        const Divider(),
        ListTile(
          leading: Icon(MingCute.book_5_fill),
          title: Text(localization.my_bestiaries_title),
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
                        localization.bestiary_tile_description(
                          bestiary.combatants.length,
                          bestiary.engine.translate(localization),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(MingCute.delete_2_fill),
                        onPressed: () async {
                          await context
                              .read<CustomBestiaryProvider>()
                              .delete(bestiary);
                          analytics.logEvent('bestiary_deleted');
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

class _DownloadTemplateButton extends StatefulWidget {
  const _DownloadTemplateButton({
    required this.analytics,
  });

  final AnalyticsService analytics;

  @override
  State<_DownloadTemplateButton> createState() =>
      _DownloadTemplateButtonState();
}

class _DownloadTemplateButtonState extends State<_DownloadTemplateButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator.adaptive();
    }

    final localization = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        final fileData = await DefaultAssetBundle.of(context)
            .load('assets/templates/templates.zip');
        await FileSaver.instance.saveFile(
          name: 'templates.zip',
          bytes: fileData.buffer.asUint8List(),
          mimeType: MimeType.zip,
        );
        setState(() {
          _loading = false;
        });
        toastification.show(
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          showProgressBar: false,
          autoCloseDuration: 5.seconds,
          title: Text(localization.bestiary_models_download_success),
        );
        await widget.analytics.logEvent('bestiary_template_download');
      },
      child: Text(localization.download_button),
    );
  }
}

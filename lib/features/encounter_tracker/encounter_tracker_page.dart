import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounter_tracker/providers/share_encounter_notifier.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/combatant_tracker_list.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_code_dialog.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_history/encounter_history.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_tracker_controls.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/go_live_button.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../database/database.dart';
import '../settings/providers/system_settings_provider.dart';
import 'providers/encounter_tracker_notifier.dart';
import 'widgets/details_panel.dart';
import 'widgets/encounter_tracker_bar.dart';

class EncounterTrackerPage extends StatelessWidget {
  const EncounterTrackerPage({
    super.key,
    required this.encounterId,
  });

  final int encounterId;

  @override
  Widget build(BuildContext context) {
    final analytics = context.read<AnalyticsService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<AuthProvider, ShareEncounterNotifier>(
          create: (context) => ShareEncounterNotifier(
            authProvider: context.read<AuthProvider>(),
            encounterId: encounterId,
          ),
          update: (_, auth, notifier) => notifier!..authProvider = auth,
        ),
        ChangeNotifierProxyProvider<ShareEncounterNotifier,
            EncounterTrackerNotifier>(
          create: (context) => EncounterTrackerNotifier(
            database: context.read<AppDatabase>(),
            settings: context.read<SystemSettingsProvider>(),
            encounterId: encounterId,
            shareEncounterNotifier: context.read<ShareEncounterNotifier>(),
          ),
          update: (_, share, tracker) =>
              tracker!..shareEncounterNotifier = share,
        ),
      ],
      child: Builder(
        builder: (context) {
          final trackerState = context.watch<EncounterTrackerNotifier>();
          final shareState = context.watch<ShareEncounterNotifier>();
          return StreamBuilder<Encounter>(
            stream: trackerState.watchEncounter(),
            builder: (context, snapshot) {
              final encounter = snapshot.data;

              if (encounter == null) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!
                      .encounter_tracker_page_title),
                  actions: [
                    GoLiveButton(
                      onPressed: () async {
                        final code = await shareState.toggleLive(encounter);
                        if (code != null) {
                          await showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) =>
                                EncounterCodeDialog(code: code),
                          );
                        }
                        await analytics
                            .logEvent('toggle_live_encounter', props: {
                          'live': (!shareState.live).toString(),
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(MingCute.history_2_fill),
                      onPressed: () async {
                        await analytics.logEvent('view_encounter_history');
                        SideSheet.right(
                          // ignore: use_build_context_synchronously
                          context: context,
                          body: EncounterHistory(
                            encounter: encounter,
                            onDeleteHistory: () async {
                              await trackerState.deleteHistory();
                              await analytics
                                  .logEvent('delete_encounter_history');
                            },
                            onUndo: (log) async {
                              await trackerState.undoLog(log);
                              await analytics
                                  .logEvent('undo_encounter_log', props: {
                                'log': log.type.toString(),
                              });
                            },
                          ),
                          // ignore: use_build_context_synchronously
                          sheetColor: Theme.of(context).canvasColor,
                        );
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      TrackerBar(
                        encounter: encounter,
                        onTitleChanged: (title) async {
                          await trackerState.editName(title);
                        },
                        onCombatantsAdded: (combatantsMap) async {
                          await context
                              .read<EncounterTrackerNotifier>()
                              .addCombatants(combatantsMap);
                        },
                      ),
                      Expanded(
                        child: _TrackerPageContent(
                          encounter: encounter,
                          trackerState: trackerState,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TrackerPageContent extends StatefulWidget {
  const _TrackerPageContent({
    required this.encounter,
    required this.trackerState,
  });

  final Encounter encounter;
  final EncounterTrackerNotifier trackerState;

  @override
  State<_TrackerPageContent> createState() => _TrackerPageContentState();
}

class _TrackerPageContentState extends State<_TrackerPageContent> {
  int? combatantIndex;
  bool detailsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        CombatantTrackerList(
          encounter: widget.encounter,
          onCombatantTap: (combatant, index) {
            setState(() {
              combatantIndex = index;
              detailsOpen = true;
            });
          },
          selectedCombatantIndex: widget.trackerState.isPlaying
              ? widget.trackerState.activeCombatantIndex
              : null,
          onCombatantsAdded: (combatants) async {
            await context
                .read<EncounterTrackerNotifier>()
                .addCombatants(combatants);
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: EncounterDetailsPanel(
            combatant: combatantIndex != null
                ? widget.encounter.combatants[combatantIndex!]
                : null,
            open: detailsOpen,
            onClose: () => setState(() {
              detailsOpen = false;
              combatantIndex = null;
            }),
            onConditionsAdded: (conditions) async {
              final combatant = widget.encounter.combatants[combatantIndex!];
              await context
                  .read<EncounterTrackerNotifier>()
                  .updateCombatantsConditions(
                    combatant,
                    conditions,
                  );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: const EncounterTrackerControls(),
        ),
      ],
    );
  }
}

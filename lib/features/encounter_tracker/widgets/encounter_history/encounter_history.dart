import 'package:battlemaster/features/encounter_tracker/widgets/encounter_history/encounter_history_tile.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

class LogGroup {
  final List<EncounterLog> logs;
  final EncounterLogType type;
  final int round;
  final int turn;

  LogGroup({
    required this.logs,
    required this.type,
    required this.round,
    required this.turn,
  });
}

class EncounterHistory extends StatelessWidget {
  const EncounterHistory({
    super.key,
    required this.encounter,
    this.onDeleteHistory,
    this.onUndo,
  });

  final Encounter encounter;
  final VoidCallback? onDeleteHistory;
  final UndoLogCallback? onUndo;

  List<LogGroup> groupLogs() {
    final groupedLogs = <Record, LogGroup>{};

    for (final log in encounter.logs) {
      final record = (log.turn, log.round, log.type);
      if (groupedLogs.containsKey(record)) {
        groupedLogs[record]!.logs.add(log);
      } else {
        groupedLogs[record] = LogGroup(
          logs: [log],
          type: log.type,
          round: log.round,
          turn: log.turn,
        );
      }
    }

    return groupedLogs.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedLogs = groupLogs();
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localization.encounter_history,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  onDeleteHistory?.call();
                  Navigator.of(context).pop();
                },
                label: Text(localization.delete_history_button),
                icon: Icon(MingCute.delete_2_fill),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: _EncounterHistoryList(
              groups: groupedLogs,
              onUndo: (log) {
                onUndo?.call(log);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EncounterHistoryList extends StatelessWidget {
  const _EncounterHistoryList({
    this.groups = const [],
    this.onUndo,
  });

  final List<LogGroup> groups;
  final UndoLogCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return EncounterHistoryTile(
          group: group,
          onUndo: (log) => onUndo?.call(log),
          showDivider: index < groups.length - 1,
        );
      },
    );
  }
}

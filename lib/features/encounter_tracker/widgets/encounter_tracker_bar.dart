import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../combatant/models/combatant.dart';
import '../providers/encounter_tracker_notifier.dart';

class TrackerBar extends StatelessWidget {
  const TrackerBar({
    super.key,
    required this.title,
    this.onCombatantsAdded,
    this.onTitleChanged,
  });

  final ValueChanged<List<Combatant>>? onCombatantsAdded;
  final String title;
  final ValueChanged<String>? onTitleChanged;

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton.outlined(
            onPressed: () {
              trackerState.playStop();
            },
            icon: Icon(
              trackerState.isPlaying ? Icons.stop : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          _TrackerTitle(
            title: title,
            onTitleChanged: onTitleChanged,
          ),
          const Spacer(),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            color: Colors.white,
            onPressed: () async {
              final combatantsMap =
                  await Navigator.of(context).pushNamed("/combatant/add");
              debugPrint(combatantsMap.toString());

              if (combatantsMap == null) {
                return;
              }

              onCombatantsAdded?.call(
                (combatantsMap as Map<Combatant, int>)
                    .entries
                    .fold<List<Combatant>>(
                  [],
                  (combatants, mapEntry) {
                    return [
                      ...combatants,
                      ...List.generate(mapEntry.value, (index) => mapEntry.key),
                    ];
                  },
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _TrackerTitle extends StatefulWidget {
  const _TrackerTitle({
    super.key,
    required this.title,
    this.onTitleChanged,
  });

  final String title;
  final ValueChanged<String>? onTitleChanged;

  @override
  State<_TrackerTitle> createState() => _TrackerTitleState();
}

class _TrackerTitleState extends State<_TrackerTitle> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                controller: _controller,
                onSubmitted: (value) {
                  widget.onTitleChanged?.call(value);
                  setState(() {
                    _isEditing = false;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onTitleChanged?.call(_controller.text);
                setState(() {
                  _isEditing = false;
                });
              },
              icon: Icon(Icons.check),
            )
          ],
        ),
      );
    }

    return Row(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}

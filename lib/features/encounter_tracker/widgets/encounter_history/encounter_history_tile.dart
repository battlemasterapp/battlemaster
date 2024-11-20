import 'package:auto_size_text/auto_size_text.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_history/encounter_history.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef UndoLogCallback = void Function(EncounterLog log);

class EncounterHistoryTile extends StatelessWidget {
  const EncounterHistoryTile({
    super.key,
    required this.group,
    this.onUndo,
    this.showDivider = true,
  });

  final LogGroup group;
  final UndoLogCallback? onUndo;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final tileKey = GlobalKey();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                group.logs.first.icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            if (showDivider)
              CustomPaint(
                painter: _StepLine(
                  key: tileKey,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
        KeyedSubtree(
          key: tileKey,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: group.logs.length == 1
                  ? _SingleLogTile(log: group.logs.first, onUndo: onUndo)
                  : _MultipleLogTile(group: group, onUndo: onUndo),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepLine extends CustomPainter {
  final GlobalKey key;
  final Color color;

  _StepLine({required this.key, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = color;
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final stepContentHeight = renderBox?.size.height ?? 0;

    canvas.drawLine(
      Offset(0, 0),
      Offset(0, stepContentHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SingleLogTile extends StatelessWidget {
  const _SingleLogTile({
    required this.log,
    this.onUndo,
    this.showRound = true,
  });

  final EncounterLog log;
  final UndoLogCallback? onUndo;
  final bool showRound;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    final children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showRound)
            Text(
              localization.encounter_history_round_turn(
                  log.round, log.turn + 1),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          Text(
            log.getTitle(localization),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          AutoSizeText(
            log.getDescription(localization),
            maxLines: 3,
          ),
        ],
      ),
      if (!isMobile)
        IconButton(
          onPressed: () => onUndo?.call(log),
          icon: Icon(MingCute.refresh_anticlockwise_1_fill),
        ),
      if (isMobile)
        OutlinedButton.icon(
          onPressed: () => onUndo?.call(log),
          label: Text(localization.undo_button),
          icon: Icon(MingCute.refresh_anticlockwise_1_fill),
        )
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: isMobile
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
    );
  }
}

class _MultipleLogTile extends StatefulWidget {
  const _MultipleLogTile({
    required this.group,
    this.onUndo,
  });

  final LogGroup group;
  final UndoLogCallback? onUndo;

  @override
  State<_MultipleLogTile> createState() => __MultipleLogTileState();
}

class __MultipleLogTileState extends State<_MultipleLogTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SingleLogTile(
          log: widget.group.logs.first,
          onUndo: widget.onUndo,
        ),
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.secondary.withOpacity(.5),
                  ),
                  padding: const EdgeInsets.all(1),
                  child: Icon(
                    MingCute.more_1_fill,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                if (!_expanded)
                  Text(
                    localization.show_more_similar_activities(
                        widget.group.logs.length - 1),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (_expanded)
                  Text(
                    localization.hide_more_similar_activities(
                        widget.group.logs.length - 1),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: widget.group.logs
                  .skip(1)
                  .map(
                    (log) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SingleLogTile(
                        log: log,
                        onUndo: widget.onUndo,
                        showRound: false,
                      ),
                    ),
                  )
                  .toList()
                  .animate(interval: 50.ms)
                  .fade(),
            ).animate().fade(duration: 300.ms),
          ),
      ],
    );
  }
}

import 'package:battlemaster/features/encounter_tracker/widgets/encounter_history/encounter_history.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';

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
                MingCute.tag_chevron_fill,
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
  });

  final EncounterLog log;
  final UndoLogCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rodada ${log.round} - Turno ${log.turn + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Ação: ${log.type.toString()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text('subtítulo (chamar método no grupo)'),
            ],
          ),
          IconButton(
            onPressed: () => onUndo?.call(log),
            icon: Icon(MingCute.refresh_anticlockwise_1_fill),
          ),
        ],
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
    // FIXME: textos
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
                    'mostrar mais ${widget.group.logs.length - 1} ações similares',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (_expanded)
                  Text(
                    'ocultar mais ${widget.group.logs.length - 1} ações similares',
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
                  .map((log) => _SingleLogTile(
                        log: log,
                        onUndo: widget.onUndo,
                      ))
                  .toList()
                  .animate(interval: 50.ms)
                  .fade(),
            ).animate().fade(duration: 300.ms),
          ),
      ],
    );
  }
}

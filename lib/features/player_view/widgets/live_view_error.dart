import 'dart:math';

import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class LiveViewError extends StatelessWidget {
  const LiveViewError({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return LayoutBuilder(builder: (context, layout) {
      final iconSize = min(128, layout.maxHeight / 3).toDouble();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FIcon(
            GI.GiBrokenSkull,
            size: iconSize,
            color: Theme.of(context).iconTheme.color ??
                Theme.of(context).textTheme.bodyMedium?.color ??
                Colors.black,
          ),
          const SizedBox(height: 16),
          Text(
            'Não foi possível conectar no combate.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<PlayerViewNotifier>().subscribe();
            },
            child: Text('Tentar novamente'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onLeave,
            child: Text('Sair'),
          ),
        ],
      );
    });
  }
}

import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/player_view/widgets/live_view.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PlayerViewPage extends StatelessWidget {
  const PlayerViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final liveViewState = context.watch<PlayerViewNotifier>();
    final code = liveViewState.code;
    if (code == null || code.length < 6) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Digite o código da sala',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              onCompleted: (value) {
                liveViewState.subscribe(code: value);
              },
            ),
          ],
        ),
      );
    }

    return LiveView(
      onLeave: () {
        liveViewState.unsubscribe();
      },
    );
  }
}

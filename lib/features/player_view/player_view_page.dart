import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/player_view/widgets/live_view.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PlayerViewPage extends StatefulWidget {
  const PlayerViewPage({super.key});

  @override
  State<PlayerViewPage> createState() => _PlayerViewPageState();
}

class _PlayerViewPageState extends State<PlayerViewPage> {
  String? _code;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    if (_code == null || _code!.length < 6) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter the code to join the game',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              onCompleted: (value) =>
                  setState(() => _code = value.toUpperCase()),
            ),
          ],
        ),
      );
    }

    return ChangeNotifierProxyProvider<AuthProvider, PlayerViewNotifier>(
      create: (context) => PlayerViewNotifier(
        code: _code!,
        auth: context.read<AuthProvider>(),
      )..subscribe(),
      update: (_, auth, notifier) => notifier!..auth = auth,
      child: LiveView(
        onLeave: () {
          setState(() => _code = null);
        },
      ),
    );
  }
}

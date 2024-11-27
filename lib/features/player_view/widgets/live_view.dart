import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_disconnected.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_error.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_loading.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class LiveView extends StatefulWidget {
  const LiveView({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  @override
  void dispose() {
    context.read<PlayerViewNotifier>().unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final localization = AppLocalizations.of(context)!;
    final liveState = context.watch<PlayerViewNotifier>();

    if (liveState.state == PlayerViewState.loading) {
      return LiveViewLoading(onLeave: () {
        liveState.unsubscribe();
        widget.onLeave?.call();
      });
    }

    if (liveState.state == PlayerViewState.error) {
      return LiveViewError(onLeave: () {
        liveState.unsubscribe();
        widget.onLeave?.call();
      });
    }

    if (liveState.state == PlayerViewState.disconnected) {
      return LiveViewDisconnected(onLeave: () {
        liveState.unsubscribe();
        widget.onLeave?.call();
      });
    }

    final encounter = liveState.encounter!;

    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32),
              Text(
                localization.round_counter(encounter.round),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  liveState.unsubscribe();
                  widget.onLeave?.call();
                },
                icon: Icon(MingCute.exit_fill),
                label: Text('Leave'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            itemCount: encounter.combatants.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final combatant = encounter.combatants[index];

              final selected = index == encounter.turn;

              return LiveViewTile(
                combatant: combatant,
                index: index,
                selected: selected,
                revealed: _isRevealed(
                  combatant,
                  encounter.round,
                  index,
                  encounter.turn,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isRevealed(Combatant combatant, int round, int index, int turn) {
    // TODO: add to the system settings
    if (combatant.type == CombatantType.player) {
      return true;
    }
    if (round > 1) {
      return true;
    }
    return index <= turn;
  }
}

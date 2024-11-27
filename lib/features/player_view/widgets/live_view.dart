import 'dart:async';

import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/player_view/models/encounter_view.dart';
import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_disconnected.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_error.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_loading.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class LiveView extends StatelessWidget {
  const LiveView({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final localization = AppLocalizations.of(context)!;
    final liveState = context.watch<PlayerViewNotifier>();

    if (liveState.state == PlayerViewState.loading) {
      return LiveViewLoading(onLeave: () {
        liveState.unsubscribe();
        onLeave?.call();
      });
    }

    if (liveState.state == PlayerViewState.error) {
      return LiveViewError(onLeave: () {
        liveState.unsubscribe();
        onLeave?.call();
      });
    }

    if (liveState.state == PlayerViewState.disconnected) {
      return LiveViewDisconnected(onLeave: () {
        liveState.unsubscribe();
        onLeave?.call();
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
                  onLeave?.call();
                },
                icon: Icon(MingCute.exit_fill),
                label: Text('Sair'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _LiveViewList(
            encounter: encounter,
          ),
        ),
      ],
    );
  }
}

class _LiveViewList extends StatefulWidget {
  const _LiveViewList({
    required this.encounter,
  });

  final EncounterView encounter;

  @override
  State<_LiveViewList> createState() => __LiveViewListState();
}

class __LiveViewListState extends State<_LiveViewList> {
  final _listController = ScrollController();
  late ListObserverController _observerController;
  StreamSubscription<int>? _sub;

  @override
  void initState() {
    super.initState();
    _observerController = ListObserverController(controller: _listController);
    _sub ??=
        context.read<PlayerViewNotifier>().activeIndexStream.listen((index) {
      _observerController.animateTo(
        index: index,
        duration: 500.ms,
        curve: Curves.easeInOutQuad,
        padding: EdgeInsets.symmetric(vertical: 16),
      );
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListViewObserver(
      controller: _observerController,
      child: ListView.separated(
        controller: _listController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        itemCount: widget.encounter.combatants.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final combatant = widget.encounter.combatants[index];
          final selected = index == widget.encounter.turn;
          final hideMonsters = widget.encounter.hideFutureCombatants;

          return LiveViewTile(
            combatant: combatant,
            index: index,
            selected: selected,
            showMonsterHealth: widget.encounter.showMonsterHealth,
            revealed: !hideMonsters ||
                _isRevealed(
                  combatant,
                  widget.encounter.round,
                  index,
                  widget.encounter.turn,
                ),
          );
        },
      ),
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

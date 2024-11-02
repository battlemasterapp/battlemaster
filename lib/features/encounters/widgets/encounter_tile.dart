import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:battlemaster/features/encounter_tracker/encounter_tracker_page.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../models/encounter.dart';
import 'encounter_tile_menu.dart';

class EncounterGridTile extends StatelessWidget {
  const EncounterGridTile({
    super.key,
    required this.encounter,
  });

  final Encounter encounter;

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(10);
    return ClipRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(.65),
                    Colors.black,
                  ],
                  stops: const [.6, 1],
                ),
                borderRadius: borderRadius,
              ),
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    "/encounter",
                    arguments: EncounterTrackerParams(encounter: encounter),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: EncounterTileMenu(
                        encounter: encounter,
                        iconColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    AutoSizeText(
                      encounter.name,
                      textAlign: TextAlign.center,
                      maxFontSize: 26,
                      minFontSize: 8,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _GroupIndicator(count: encounter.combatants.length),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupIndicator extends StatelessWidget {
  const _GroupIndicator({
    this.count = 0,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LineAwesome.users_solid,
          color: Colors.white.withOpacity(.7),
        ),
        const SizedBox(width: 4),
        Text(
          "$count",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white.withOpacity(.7)),
        ),
      ],
    );
  }
}

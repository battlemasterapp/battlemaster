import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../encounter_tracker/encounter_tracker_page.dart';
import '../../groups/group_detail_page.dart';
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
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).primaryColor,
        ),
        child: InkWell(
          onTap: () {
            if (encounter.isEncounter) {
              Navigator.of(context).pushNamed(
                "/encounter",
                arguments: EncounterTrackerParams(encounter: encounter),
              );
              return;
            }
            Navigator.of(context).pushNamed(
              "/group",
              arguments: GroupDetailPageParams(encounter: encounter),
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

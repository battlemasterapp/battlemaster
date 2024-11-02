import 'package:battlemaster/features/encounters/widgets/encounters_grid.dart';
import 'package:flutter/material.dart';

class CombatsPage extends StatelessWidget {
  const CombatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: EncountersGrid(),
        ),
      ],
    );
  }
}

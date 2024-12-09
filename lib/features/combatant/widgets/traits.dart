import 'package:flutter/material.dart';

import '../../../flavors/pf2e/pf2e_colors.dart';

class Traits extends StatelessWidget {
  const Traits({super.key, required this.traits});

  final List<String> traits;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        for (final trait in traits) Trait(text: trait),
      ],
    );
  }
}

class Trait extends StatelessWidget {
  const Trait({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getColor(),
        border: Border.all(color: traitBorder, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  Color getColor() {
    final alignments = ["LG", "NG", "CG", "LN", "N", "CN", "LE", "NE", "CE"];
    final sizes = ["tiny", "small", "medium", "large", "huge", "gargantuan"];

    if (sizes.contains(text)) {
      return mainGreen;
    }

    if (alignments.contains(text.toUpperCase())) {
      return alingmentBlue;
    }

    if (text == "rare") {
      return mainBlue;
    }

    if (text == "uncommon") {
      return uncommonColor;
    }

    if (text == "unique") {
      return uniqueColor;
    }

    return mainRed;
  }
}

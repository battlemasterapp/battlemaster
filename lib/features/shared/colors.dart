import 'dart:math';

import 'package:flutter/material.dart';

Color getHealthColor(int currentHp, {int maxHp = 0}) {
  const fullHealthColor = Colors.green;
  const halfHealthColor = Colors.orange;
  const deadColor = Colors.red;

  if (currentHp == 0) {
    return deadColor;
  }

  if (maxHp == 0) {
    return Color.lerp(
      fullHealthColor,
      deadColor,
      1 - (currentHp / (max(maxHp, currentHp))),
    )!;
  }

  final halfHealth = maxHp / 2;

  if (currentHp >= halfHealth) {
    return Color.lerp(
      fullHealthColor,
      halfHealthColor,
      1 - ((currentHp - halfHealth) / halfHealth),
    )!;
  }

  return Color.lerp(
    halfHealthColor,
    deadColor,
    1 - (currentHp / (max(maxHp, currentHp) - halfHealth)),
  )!;
}

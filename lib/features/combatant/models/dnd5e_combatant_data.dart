import 'package:battlemaster/features/combatant/models/combatant_data.dart';

class Dnd5eCombatantData extends CombatantData {
  Dnd5eCombatantData({super.rawData});

  String get name => rawData['name'] ?? "";

  int get hp => rawData['hit_points'] ?? 0;

  int get ac => rawData['armor_class'] ?? 0;

  int get initiativeModifier {
    final dex = rawData['dexterity'] as int? ?? 0;
    return ((dex - 10) / 2).floor();
  }

  double get level => rawData['cr'] ?? 0;

  String get challengeRating => rawData['challenge_rating'] ?? level.toString();

  String get source => rawData['document__title'] ?? '';

  String get size => rawData['size'] ?? '';

  String get type => rawData['type'] ?? '';

  String get subtype => rawData['subtype'] ?? '';

  String get alignment => rawData['alignment'] ?? '';
}

const _rkTraitSkillMap = <String, List<String>>{
  "aberration": ["occultism"],
  "animal": ["nature"],
  "astral": ["occultism"],
  "beast": ["arcana", "nature"],
  "celestial": ["religion"],
  "construct": ["arcana", "crafting"],
  "dragon": ["arcana"],
  "dream": ["occultism"],
  "elemental": ["arcana", "nature"],
  "ethereal": ["occultism"],
  "fey": ["nature"],
  "fiend": ["religion"],
  "fungus": ["nature"],
  "humanoid": ["society"],
  "monitor": ["religion"],
  "ooze": ["occultism"],
  "plant": ["nature"],
  "shade": ["religion"],
  "spirit": ["occultism"],
  "time": ["occultism"],
  "undead": ["religion"],
};

const _dcByLevel = <int>[
  14,
  15,
  16,
  18,
  19,
  20,
  22,
  23,
  24,
  26,
  27,
  28,
  30,
  31,
  32,
  34,
  35,
  36,
  38,
  39,
  40,
  42,
  44,
  46,
  48,
  50,
];

const _traitAdjustment = <String, int>{
  "uncommon": 2,
  "rare": 5,
  "unique": 10,
};

class RecallKnowledgeEntry {
  late List<String> _skills;
  late int _dc;

  RecallKnowledgeEntry({
    required List<String> traits,
    required int level,
  }) {
    final skillsSet = <String>{};
    for (final trait in traits) {
      final traitSkills = _rkTraitSkillMap[trait.toLowerCase()];
      if (traitSkills != null) {
        skillsSet.addAll(traitSkills);
      }
    }
    _skills = skillsSet.toList();

    _dc = _calculateDC(traits, level);
  }

  List<String> get skills => _skills;

  int get dc => _dc;

  int get unspecificDC => _dc - 2;

  int get specificDC => _dc - 5;

  int _calculateDC(List<String> traits, int level) {
    final adjustment = traits
        .map((trait) => _traitAdjustment[trait.toLowerCase()] ?? 0)
        .fold<int>(0, (a, b) => a + b);
    if (level < 0) {
      return _dcByLevel.first - 1 + adjustment;
    }
    if (level > 25) {
      return _dcByLevel.last + adjustment;
    }
    return _dcByLevel[level] + adjustment;
  }
}

# Combatant class

The `Combatant` class represents a combatant in the combat tracker. It holds the basic attributes of a combatant, such as name, hit points, armor class, and initiative. It also has a reference to the game engine, which defines the rules for combat.

**Basic attributes**
- name: String
- current_hp: int
- max_hp: int
- ac: int
- initiative: int?
- initiative_modifier: int
- conditions: List<Condition>
- type: String(player, monster, hazard, lair)
- engine: String(5e, pf2e, custom)
- monsterData: MonsterData?

**Derived attributes**
- wounded: bool
- dead: bool
- initiative_roll: int

## MonsterData

An abstract class that represents the data of a monster. For each game engine, there will be a subclass of MonsterData that will define the attributes of the monster.

### 5eMonsterData

**Attributes**

- size: String
- type: String
- alignment: String
- cr: int
- str: int
- dex: int
- con: int
- int: int
- wis: int
- cha: int

### Pf2eMonsterData

**Attributes**
- str: int
- dex: int
- con: int
- int: int
- wis: int
- cha: int
- traits: List<String>
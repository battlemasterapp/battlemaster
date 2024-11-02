# Encounter class

The `Encounter` class is the main class for the combat tracker. It holds the list of combatants and the current round. 
It also has a reference to the game engine, which defines the rules for combat.

**Attributes**

- name: String
- round: int
- combatants: List<Combatant>
- engine: String(5e, pf2e, custom)
# BattleMaster

## Features

Combat has a game engine selected: 5e, pf2e or custom. The game engine defines the rules for combat, including the attributes of combatants and the conditions that can be applied.

### Combats

- User can create combats with a name and a game engine
- User can create custom groups of combatants

### Initiative tracker

- Users can add combatants: add custom combatants or select from a list of pre-defined monsters
- Users can manage combatant HP
- Display basic combatant attributes on the tracker
- Display combatant sheet on a panel/window
- Roll initiative
  - Users can toggle to auto-roll for enemies
  - Users can insert initiative
- Users can check off monster abilities that have been used
- Users can check off if a combatant has spent their reaction
- User can toggle reminders for combatants abilities (fast-healing, etc)

### Conditions

- Add conditions to combatants (5e, pf2e, custom)
- Users can add temporary conditions that expire after X turns
  - The app shows a dialog when a condition expires
- Users can ddd custom conditions

### Monsters

- Choose data source: 5e SRD, pf2e bestiaries
  - 5e SRD monsters
  - pf2e bestiaries from foundry data
- Import from CSV file

### Player features

- Player facing view of the combat (requires a server?)
- Player can add their initiative to the tracker
- Monster health displayed with words like "wounded" or "uninjured"

## Technologies

- flutter flavors for different versions: https://docs.flutter.dev/deployment/flavors#setting-up-launch-configurations
- drift: https://pub.dev/packages/drift

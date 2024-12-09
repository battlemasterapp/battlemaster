# Battlemaster
Battlemaster is a combat management tool for tabletop RPGs, supporting systems such as D&D 5e, Pathfinder 2e, and custom game engines. It focuses on assisting the game master in tracking combatants, managing initiative, and applying game-specific rules during combat encounters.

See it in action at [app.battlemaster.com.br](https://app.battlemaster.com.br) or download and install the app from the releases page.

## Features
### Combat Management
**Combat Creation**: Easily create and name combats, and organize custom groups of combatants.

### Initiative Tracker
**Combatants**: Add combatants either manually or by selecting from predefined monsters.
**HP Management**: Keep track of combatant health.
**Attributes**: Display basic combatant stats in the tracker and detailed sheets in a separate panel.
**Initiative Rolling**: Roll initiative manually or toggle auto-rolling.

### Conditions
**Apply Conditions**: Manage conditions (5e, pf2e, or custom);
**Custom Conditions**: Add your own conditions to tailor the combat experience.

### Monster Management
**Monster Sources**: Select from 5e SRD monsters or Pathfinder 2e bestiaries.
**Custom Import**: Import monsters via CSV or JSON files.

### Player Features
**Player View**: Show a simplified combat view for players, including health statuses like "wounded" or "uninjured" for monsters.

## Development
### Build Instructions
To build the project, use the following commands:

```bash
flutter gen-l10n
dart run build_runner build
dart run drift_dev make-migrations
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```
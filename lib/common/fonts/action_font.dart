enum ActionsEnum { one, two, three, free, reaction }

extension ActionString on ActionsEnum {
  String toActionString() {
    switch (this) {
      case ActionsEnum.one:
        return "\u00E1";
      case ActionsEnum.two:
        return "\u00E2";
      case ActionsEnum.three:
        return "\u00E3";
      case ActionsEnum.free:
        return "\u00E0";
      case ActionsEnum.reaction:
        return "\u00E4";
    }
  }
}

String actionToString(ActionsEnum action) {
  return action.toActionString();
}

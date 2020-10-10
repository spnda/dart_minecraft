dart_minecraft
==============

[![Pub Package](https://img.shields.io/pub/v/dart_minecraft.svg)](https://pub.dev/packages/dart_minecraft)
[![GitHub Issues](https://img.shields.io/github/issues/spnda/dart_minecraft.svg)](https://github.com/spnda/dart_minecraft/issues)
[![GitHub Stars](https://img.shields.io/github/stars/spnda/dart_minecraft.svg)](https://github.com/spnda/dart_minecraft/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/spnda/dart_minecraft/main/LICENSE)

A simple Dart library for interfacing with the Mojang and Minecraft APIs.

Examples
--------

### Skin/Cape of a player

```dart
void main() async {
    Pair player = await Mojang.getUuid('<your username>');
    Profile profile = await Mojang.getProfile(player.getSecond);
    String url = profile.getTextures.getSkinUrl();
}
```

### Name history of a player

```dart
void main() async {
    String uuid = await Mojang.getUuid('<your username>');
    List<Name> history = await Mojang.getNameHistory(uuid);
    history.forEach((Name name) => print(name.getName));
}
```

Planned
--------

- [x] Support for all the Minecraft and Minecraft Launcher APIs.
- [ ] Support for launching Minecraft itself.
- [ ] Support for seeing and joining a Minecraft Server.

License
--------

The MIT License, see [LICENSE](https://github.com/spnda/dart_minecraft/raw/main/LICENSE).

# dart_minecraft

[![Pub Package](https://img.shields.io/pub/v/dart_minecraft.svg?style=for-the-badge&logo=Dart)](https://pub.dev/packages/dart_minecraft)
[![GitHub Issues](https://img.shields.io/github/issues/spnda/dart_minecraft.svg?style=for-the-badge&logo=GitHub)](https://github.com/spnda/dart_minecraft/issues)
[![GitHub Stars](https://img.shields.io/github/stars/spnda/dart_minecraft.svg?style=for-the-badge&logo=GitHub)](https://github.com/spnda/dart_minecraft/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=GitHub)](https://raw.githubusercontent.com/spnda/dart_minecraft/main/LICENSE)

A simple Dart library for interfacing with the Mojang and Minecraft APIs.
It also includes NBT read/write functionality and functions to ping Minecraft: Java Edition
servers.

You can simply import the library like this:
```dart
import 'package:dart_minecraft/dart_minecraft.dart';
```

## Examples

Below are some basic examples of the features included in this library. A better and more
extensive example can be found [here](https://github.com/spnda/dart_minecraft/tree/main/example).
However you should always keep in mind that there is a rate limit on all API, set at 600 requests
per 10 minutes. You are expected to cache the results and this is **not** done by the library itself.

### Skin/Cape of a player

Get the skin and/or cape texture URL of a player. This just requires the player's UUID or username.

```dart
void main() async {
    // PlayerUUID is a Pair<String, String>
    PlayerUuid player = await getUuid('<your username>');
    Profile profile = await getProfile(player.second);
    String url = profile.textures.getSkinUrl();
}
```

### Reading NBT data

Read NBT data from a local file. This supports the full NBT specification, however
support for SNBT is not implemented yet. A full list of tags/types usable in this
context can be found [here](https://github.com/spnda/dart_minecraft/tree/main/lib/src/nbt/tags).

```dart
void main() async {
    // You can create a NbtFile object from a File object or
    // from a String path.
    final nbtReader = NbtReader.fromFile('yourfile.nbt');
    await nbtReader.read();
    NbtCompound rootNode = nbtReader.root;
    // You can now read information from your [rootNode].
    // for example, rootNode[0] will return the first child,
    // if present.
    print(rootNode.first);
    print(rootNode.getChildrenByTag(NbtTagType.TAG_STRING));
}
```

### Pinging a server

Pings the Minecraft: Java Edition (1.6+) server at 'mc.hypixel.net'. You can use any
DNS or IP Address to ping them. The server will provide basic information, as the player
count, ping and MOTD.

```dart
void main() async {
	/// Pinging a server and getting its basic information is 
	/// as easy as that.
	final server = await ping('mc.hypixel.net');
	if (server == null || server.response == null) return;
	print('Latency: ${server.ping}');
	final players = ping.response!.players;
	print('${players.online} / ${players.max}'); // e.g. 5 / 20
}
```

## License

The MIT License, see [LICENSE](https://github.com/spnda/dart_minecraft/raw/main/LICENSE).

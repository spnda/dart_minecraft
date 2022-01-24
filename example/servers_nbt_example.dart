import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/dart_nbt.dart';

void main() async {
  /// In this example we will read from a "servers.dat" file,
  /// which you can find in your ".minecraft" folder. This file
  /// contains a list of all the multiplayer servers you've saved,
  /// including IP, name, icon and if you want to automatically accept
  /// and use the server's resource pack. We will read this file and
  /// go over each server and ping that server, using the ping() method
  /// from this package.
  final nbtFile = NbtReader.fromFile('./example/servers.dat');
  try {
    nbtFile.read();
  } on NbtFileReadException {
    print('Cannot read servers.dat');
  }

  /// If you have not supplied a servers.dat file to read from, we'll
  /// fill in some basic servers as an example.
  nbtFile.root ??= NbtCompound(name: '', children: [
    NbtList(
      name: 'servers',
      children: <NbtCompound>[
        NbtCompound(name: '', children: [
          NbtString(name: 'ip', value: 'mc.hypixel.net'),
          NbtString(name: 'name', value: 'Hypixel'),
        ]),
      ],
    )
  ]);

  /// As we now have NBT data stored in our [NbtFile], we
  /// will begin reading from it and pinging the first
  /// server we have saved.
  final serverList = nbtFile.root!.children.first;
  if (serverList is! NbtList) {
    print('Server list was in an unexpected format: ${serverList.runtimeType}');
    return;
  }
  for (var tag in serverList.children) {
    if (tag is! NbtCompound) continue;
    final ip = tag.getChildrenByName('ip');

    try {
      final server = await pingUri(ip.first.value);
      if (server == null || server.response == null) continue;
      final players = server.response!.players;
      print('Pinged ${ip.first.value}...');
      print('${players.online} / ${players.max}. ${server.ping}ms.');
    } on PingException {
      /// If we were unable to connect to the IP we found,
      /// a [PingException] is thrown. In our case, we will
      /// ignore this and just continue pinging the next IP.
      continue;
    }
  }
}

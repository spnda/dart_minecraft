import 'package:dart_minecraft/src/Mojang/Status/MojangStatus.dart';
import 'package:test/test.dart';
import 'package:dart_minecraft/minecraft.dart';

void main() {
  final username = 'spnda';
  var uuid;
  
  test('API should return UUID for username', () async {
    uuid = (await Mojang.getUuid(username)).getSecond;
    expect(uuid, equals('abf18c33e1464c2f987b0ee342f4ec9f'));
  });

  test('API should return a list of pairs with the sites status.', () async {
    final status = await Mojang.checkStatus();
    expect(status.minecraft, equals(MojangSiteStatus.Unavailable));
  });

  test('API should return link to the skin of given player.', () async {
    final profile = await Mojang.getProfile(uuid);
    final skin = profile.getTextures.getSkinUrl();
    expect(skin, 'http://textures.minecraft.net/texture/38ed123c7e0d849e24b04b1e8a99b7d4f15bd9f3dfae95deec25835c22041341');
  });

  test('API should return a list of names', () async {
    //final nameHistory = await Mojang.getNameHistory(uuid);
    //nameHistory.forEach((Name f) => print(f));
    /// final nameHistory = await Mojang.getNameHistory(uuid);
    /// final names = <Name>[
    ///   Name({'name':'imperielpanda', 'changedToAt': null}),
    ///   Name({'name':'ThePandaX','changedToAt':1455820069000}),
    ///   Name({'name':'PPNDA','changedToAt':1532270636000}),
    ///   Name({'name':'spnda','changedToAt':1596574791000}),
    /// ];
    /// assert(nameHistory.length != names.length);
    /// for (var i = 0; i < nameHistory.length; i++) {
    ///   assert(nameHistory[i] == names[i]);
    /// }
  });
}

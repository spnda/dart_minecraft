import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:test/test.dart';

void main() async {
  test('Test if version manifest reports correctly.', () async {
    /// Test whether the version manifest works properly
    /// and has some values.
    final versionManifest = await getVersions();
    expect(versionManifest, isA<VersionManifest>());
    expect(versionManifest.versions, isNotEmpty);
    expect(versionManifest.versions.where((v) {
      return v.id == '1.18.1';
    }), isNotEmpty);
  });

  test('Test if the patch notes are empty or not.', () async {
    final patchNotes = await getPatchNotes();
    expect(patchNotes, isNotEmpty);

    /// We check if the version string is empty and if it has a length
    /// of 4 or more, as (e.g.) 1.17 has 4 characters, and the version String
    /// is not getting shorter anytime soon.
    expect(patchNotes.first.version,
        (String item) => item.isNotEmpty && item.length >= 4);
  });

  test('Test if Minecraft news exists', () async {
    final news = await getNews();
    expect(news, isNotEmpty);
  });
}

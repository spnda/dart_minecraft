import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'minecraft/minecraft_news.dart';
import 'minecraft/minecraft_patch.dart';
import 'minecraft/version_manifest.dart';
import 'utilities/web_util.dart';

const String _launcherContentApi = 'launchercontent.mojang.com';
const String _launcherMetaApi = 'launchermeta.mojang.com';

/// Be careful, this API only works with https://
const String _librariesApi = 'https://libraries.minecraft.net/';
const String _resourcesApi = 'http://resources.download.minecraft.net/';

/// Returns a List of the most recent news for Minecraft.
///
/// This data can be found on the "News" page in the official
/// Minecraft Launcher.
Future<List<MinecraftNews>> getNews() async {
  final response =
      await request(http.get, _launcherContentApi, 'javaNews.json');
  final data = parseResponseMap(response);
  final news = <MinecraftNews>[];
  for (Map<String, dynamic> e in data['entries']) {
    news.add(MinecraftNews.fromJson(e));
  }
  return news;
}

/// Returns a List of the most recent patch notes for Minecraft: Java Edition.
///
/// These can also be found in the official Minecraft Launcher under
/// the "patch notes" page.
Future<List<MinecraftPatch>> getPatchNotes() async {
  final response =
      await request(http.get, _launcherContentApi, 'javaPatchNotes.json');
  final data = parseResponseMap(response);
  final patches = <MinecraftPatch>[];
  for (Map<String, dynamic> e in data['entries']) {
    patches.add(MinecraftPatch.fromJson(e));
  }
  return patches;
}

/// Returns a Manifest with all Minecraft: Java Edition Versions,
/// including alpha/beta and snapshot versions.
Future<VersionManifest> getVersions() async {
  final response = await request(
      http.get, _launcherMetaApi, 'mc/game/version_manifest_v2.json');
  final data = parseResponseMap(response);
  return VersionManifest.fromJson(data);
}

/// Get the URL for a maven library.
/// The [os] string should be null or "linux", "windows" or "osx".
String getLibraryUrl(String package, String name, String version,
    {String? os}) {
  var jarFileName =
      os == null ? '$name-$version.jar' : '$name-$version-natives-$os';
  return join(_librariesApi, package, name, version, jarFileName);
}

/// Get the resource URL for a given [hash].
String getResourceUrl(String hash) {
  return join(_resourcesApi, hash.substring(0, 2), hash);
}

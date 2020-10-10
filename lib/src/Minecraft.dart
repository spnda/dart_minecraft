import 'package:dart_minecraft/src/Minecraft/MinecraftNews.dart';
import 'package:dart_minecraft/src/Minecraft/MinecraftPatch.dart';
import 'package:dart_minecraft/src/Minecraft/VersionManifest.dart';
import 'package:dart_minecraft/src/utilities/WebUtil.dart';

/// Includes all Minecraft and Minecraft Launcher specific functionality.
class Minecraft {
  static const String _launcherContent = 'https://launchercontent.mojang.com';
  static const String _launcherMeta    = 'https://launchermeta.mojang.com/';

  /// Get's the recent news for Minecraft.
  /// 
  /// This data can be found on the "News" page in the official
  /// Minecraft Launcher.
  Future<List<MinecraftNews>> getNews() async {
    final response = (await WebUtil.get(_launcherContent, 'javaNews.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    final news = <MinecraftNews>[];
    for (Map<String, dynamic> e in data['entries']) {
      news.add(MinecraftNews.fromJson(e));
    }
    return news;
  }

  /// Get's a list of all patch notes.
  /// 
  /// These can also be found in the official Minecraft Launcher under
  /// the "patch notes" page.
  Future<List<MinecraftPatch>> getPatchNotes() async {
    final response = (await WebUtil.get(_launcherContent, 'javaPatchNotes.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    final patches = <MinecraftPatch>[];
    for (Map<String, dynamic> e in data['entries']) {
      patches.add(MinecraftPatch.fromJson(e));
    }
    return patches;
  }

  /// Get's all versions (including snapshot and alpha/beta versions) and the latest version.
  Future<VersionManifest> getVersions() async {
    final response = (await WebUtil.get(_launcherMeta, 'mc/game/version_manifest.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    return VersionManifest.fromJson(data);
  }
}

import 'minecraft/minecraft_news.dart';
import 'minecraft/minecraft_patch.dart';
import 'minecraft/version_manifest.dart';
import 'minecraft_api.dart' as api;

/// Includes all Minecraft and Minecraft Launcher specific functionality.
@deprecated
class Minecraft {
  /// Returns a List of the most recent news for Minecraft.
  ///
  /// This data can be found on the "News" page in the official
  /// Minecraft Launcher.
  @deprecated
  static Future<List<MinecraftNews>> getNews() async {
    return api.getNews();
  }

  /// Returns a List of the most recent patch notes for Minecraft: Java Edition.
  ///
  /// These can also be found in the official Minecraft Launcher under
  /// the "patch notes" page.
  @deprecated
  static Future<List<MinecraftPatch>> getPatchNotes() async {
    return api.getPatchNotes();
  }

  /// Returns a Manifest with all Minecraft: Java Edition Versions,
  /// including alpha/beta and snapshot versions.
  @deprecated
  static Future<VersionManifest> getVersions() async {
    return api.getVersions();
  }
}

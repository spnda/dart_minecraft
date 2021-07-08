/// The status of a site.
///
/// See `MojangStatus.parse("str")`.
enum MojangSiteStatus {
  /// If the site is available and fully operational.
  available,

  /// The site might be available, very slow or partially not working.
  someIssues,

  /// The site is not operational and is most likely not accessible at all.
  unavailable,
}

/// Contains the MojangSiteStatus of all Minecraft and Mojang sites.
class MojangStatus {
  /// The mojang site status for a single site. See [MojangSiteStatus] for more
  /// details on possible values.
  MojangSiteStatus? minecraft,
      minecraftSession,
      mojangAccount,
      mojangAuth,
      minecraftSkins,
      mojangAuthserver,
      mojangSessionserver,
      mojangApi,
      minecraftTextures,
      mojang;

  MojangStatus.empty();

  /// Parse all [MojangSiteStatus]s from JSON data from the Web API.
  MojangStatus.fromJson(List data) {
    for (final element in data) {
      final entry = element.entries.first;
      switch (entry.key) {
        case 'minecraft.net':
          minecraft = parse(entry.value);
          break;
        case 'session.minecraft.net':
          minecraftSession = parse(entry.value);
          break;
        case 'account.mojang.com':
          mojangAccount = parse(entry.value);
          break;
        case 'auth.mojang.com':
          mojangAuth = parse(entry.value);
          break;
        case 'skins.minecraft.net':
          minecraftSkins = parse(entry.value);
          break;
        case 'authserver.mojang.com':
          mojangAuthserver = parse(entry.value);
          break;
        case 'sessionserver.mojang.com':
          mojangSessionserver = parse(entry.value);
          break;
        case 'api.mojang.com':
          mojangApi = parse(entry.value);
          break;
        case 'textures.minecraft.net':
          minecraftTextures = parse(entry.value);
          break;
        case 'mojang.com':
          mojang = parse(entry.value);
          break;
      }
    }
  }

  /// Gets the [MojangSiteStatus] from given [data].
  /// [data] should be 'red', 'yellow', 'green'. Otherwise,
  /// [MojangSiteStatus.Unavailable] will be returned.
  static MojangSiteStatus parse(String data) {
    switch (data) {
      case 'red':
        return MojangSiteStatus.unavailable;
      case 'yellow':
        return MojangSiteStatus.someIssues;
      case 'green':
        return MojangSiteStatus.available;
      default:
        return MojangSiteStatus.unavailable;
    }
  }
}

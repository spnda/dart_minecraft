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
  MojangSiteStatus minecraft,
      minecraftSession,
      mojangAccount,
      mojangAuth,
      minecraftSkins,
      mojangAuthserver,
      mojangSessionserver,
      mojangApi,
      minecraftTextures,
      mojang;

  MojangStatus._();

  /// Parse all [MojangSiteStatus]s from JSON data from the Web API.
  factory MojangStatus.fromJson(List data) {
    final status = MojangStatus._();
    for (final element in data) {
      final entry = element.entries.first;
      switch (entry.key) {
        case 'minecraft.net':
          status.minecraft = parse(entry.value);
          break;
        case 'session.minecraft.net':
          status.minecraftSession = parse(entry.value);
          break;
        case 'account.mojang.com':
          status.mojangAccount = parse(entry.value);
          break;
        case 'auth.mojang.com':
          status.mojangAuth = parse(entry.value);
          break;
        case 'skins.minecraft.net':
          status.minecraftSkins = parse(entry.value);
          break;
        case 'authserver.mojang.com':
          status.mojangAuthserver = parse(entry.value);
          break;
        case 'sessionserver.mojang.com':
          status.mojangSessionserver = parse(entry.value);
          break;
        case 'api.mojang.com':
          status.mojangApi = parse(entry.value);
          break;
        case 'textures.minecraft.net':
          status.minecraftTextures = parse(entry.value);
          break;
        case 'mojang.com':
          status.mojang = parse(entry.value);
          break;
      }
    };
    return status;
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

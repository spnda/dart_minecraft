enum MojangSiteStatus {
  Available,
  SomeIssues,
  Unavailable,
}

class MojangStatus {
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

  factory MojangStatus.fromJson(List data) {
    final status = MojangStatus._();
    data.forEach((element) {
      final entry = element.entries.first;
      switch (entry.key) {
        case 'minecraft.net':             status.minecraft = parse(entry.value);            break;
        case 'session.minecraft.net':     status.minecraftSession = parse(entry.value);     break;
        case 'account.mojang.com':        status.mojangAccount = parse(entry.value);        break;
        case 'auth.mojang.com':           status.mojangAuth = parse(entry.value);           break;
        case 'skins.minecraft.net':       status.minecraftSkins = parse(entry.value);       break;
        case 'authserver.mojang.com':     status.mojangAuthserver = parse(entry.value);     break;
        case 'sessionserver.mojang.com':  status.mojangSessionserver = parse(entry.value);  break;
        case 'api.mojang.com':            status.mojangApi = parse(entry.value);            break;
        case 'textures.minecraft.net':    status.minecraftTextures = parse(entry.value);    break;
        case 'mojang.com':                status.mojang = parse(entry.value);               break;
      } 
    });
    return status;
  }

  /// Gets the [MojangSiteStatus] from given [data].
  /// [data] should be 'red', 'yellow', 'green'.
  static MojangSiteStatus parse(String data) {
    switch (data) {
      case 'red': return MojangSiteStatus.Unavailable;
      case 'yellow': return MojangSiteStatus.SomeIssues;
      case 'green': return MojangSiteStatus.Available;
      default: return MojangSiteStatus.Unavailable;
    }
  }
}

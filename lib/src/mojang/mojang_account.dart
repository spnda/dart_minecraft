/// A MojangAccount with data as returned by /authenticate.
class MojangAccount {
  /// The access token used to access APIs and authenticate to Minecraft Servers.
  ///
  /// This token is a replacement for logging in using a username and password each time,
  /// so keep good track of it!
  String accessToken;

  /// This account's client token.
  String clientToken;

  /// This account's user.
  MojangUser user;

  /// The currently selected user profile.
  MojangProfile selectedProfile;

  /// All available profiles.
  List<MojangProfile> availableProfiles = <MojangProfile>[];

  MojangAccount.fromJson(Map<String, dynamic> data)
      : user = MojangUser.fromJson(data['user'] ?? {}),
        selectedProfile = MojangProfile.fromJson(data['selectedProfile'] ?? {}),
        accessToken = data['accessToken'],
        clientToken = data['clientToken'];
}

/// A Mojang User. One MojangAccount always has one MojangUser.
class MojangUser {
  String username;
  String id;
  String email;
  String registerIp;
  String migratedFrom;
  int migratedAt;
  int registeredAt;
  int passwordChangedAt;
  int dateOfBirth;
  bool suspended;
  bool blocked;
  bool secured;

  /// Seems to be always false, no matter if the user has migrated or not.
  /// See https://bugs.mojang.com/browse/WEB-1461
  bool migrated;
  bool emailVerified;
  bool legacyUser;
  bool verifiedByParent;
  String preferredLanguage;
  String twitchOAuthToken;

  MojangUser.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        id = data['id'],
        email = data['email'],
        registerIp = data['registerIp'],
        migratedFrom = data['migratedFrom'],
        migratedAt = data['migratedAt'],
        registeredAt = data['registeredAt'],
        passwordChangedAt = data['passwordChangedAt'],
        dateOfBirth = data['dateOfBirth'],
        suspended = data['suspended'],
        blocked = data['blocked'],
        secured = data['secured'],
        migrated = data['migrated'],
        emailVerified = data['emailVerified'],
        legacyUser = data['legacyUser'],
        verifiedByParent = data['verifiedByParent'],
        preferredLanguage = (data['properties'] as List)
            .where((f) => (f as Map)['name'] == 'preferredLanguage')
            .first,
        twitchOAuthToken = (data['properties'] as List)
            .where((f) => (f as Map)['name'] == 'twitch_access_token')
            .first;
}

/// A Mojang Profile
class MojangProfile {
  /// The name of the player.
  String name;

  /// The player's Uuid without dashes.
  String id;

  /// Hex string
  String userId;

  /// The agent, e.g. 'minecraft'
  String agent;

  /// Timestamp when this profile was created.
  int createdAt;

  /// If this profile is legacy and is not yet migrated.
  bool legacy;

  /// If this profile is paid or not. (It most likely is.)
  bool paid;

  /// If this profile is suspended. (It most likely isn't.)
  bool suspended;

  MojangProfile.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        id = data['id'],
        userId = data['userId'],
        agent = data['agent'],
        createdAt = data['createdAt'],
        legacy = data['legacyProfile'],
        paid = data['paid'],
        suspended = data['suspended'];
}

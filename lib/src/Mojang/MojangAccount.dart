/// A MojangAccount with data as returned by /authenticate.
/// 
/// After a refresh, some of these values might be null.
class MojangAccount {
  String accessToken, clientToken;
  MojangUser user;
  MojangProfile selectedProfile;
  List<MojangProfile> availableProfiles;

  MojangAccount._();

  factory MojangAccount.fromJson(Map<String, dynamic> data) => MojangAccount._()
    ..user = MojangUser.fromJson(data['user'] ?? {})
    ..selectedProfile = MojangProfile.fromJson(data['selectedProfile'] ?? {})
    ..accessToken = data['accessToken']
    ..clientToken = data['clientToken'];
}

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
  /// Seems to be always false, no matter if the user has migrated or not. See https://bugs.mojang.com/browse/WEB-1461
  bool migrated;
  bool emailVerified;
  bool legacyUser;
  bool verifiedByParent;
  String preferredLanguage;
  String twitchOAuthToken;

  MojangUser._();

  factory MojangUser.fromJson(Map<String, dynamic> data) => MojangUser._()
    ..username = data['username']
    ..id = data['id']
    ..email = data['email']
    ..registerIp = data['registerIp']
    ..migratedFrom = data['migratedFrom']
    ..migratedAt = data['migratedAt']
    ..passwordChangedAt = data['passwordChangedAt']
    ..dateOfBirth = data['dateOfBirth']
    ..suspended = data['suspended']
    ..blocked = data['blocked']
    ..secured = data['secured']
    ..migrated = data['migrated']
    ..emailVerified = data['emailVerified']
    ..legacyUser = data['legacyUser']
    ..verifiedByParent = data['verifiedByParent']
    ..preferredLanguage = (data['properties'] as List)?.where((f) => (f as Map)['name'] == 'preferredLanguage')?.first
    ..twitchOAuthToken = (data['properties'] as List)?.where((f) => (f as Map)['name'] == 'twitch_access_token')?.first;
}

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

  MojangProfile._();

  factory MojangProfile.fromJson(Map<String, dynamic> data) => MojangProfile._()
    ..name = data['name']
    ..id = data['id']
    ..userId = data['userId']
    ..agent = data['agent']
    ..createdAt = data['createdAt']
    ..legacy = data['legacyProfile']
    ..paid = data['paid']
    ..suspended = data['suspended'];
}

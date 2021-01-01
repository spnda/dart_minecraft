import 'dart:convert';

/// A Minecraft user including their skin/cape.
class Profile {
  String _id;
  String _name;
  String _textures;
  String _signatures;

  Profile._();

  factory Profile.fromJson(Map<String, dynamic> json) => Profile._()
    .._id = json['id']
    .._name = json['name']
    .._textures = json['properties'][0]['value'];

  /// The UUID of this player.
  String get getUuid => _id;

  /// This player's name.
  String get getName => _name;

  /// Returns a ProfileTextures including this players' skin and cape textures.
  ProfileTextures get getTextures => ProfileTextures.fromJson(
      json.decode(utf8.decode(base64.decode(_textures))));

  /// This is a yggdrasil-server-only feature. It is basically useless towards a player or dev.
  String get getSignature => utf8.decode(base64.decode(_signatures ?? ''));
}

class ProfileTextures {
  int _timestamp;
  String _profileId;
  String _profileName;
  String _skinUrl;
  String _capeUrl;
  // bool _signatureRequired;

  ProfileTextures._();

  factory ProfileTextures.fromJson(Map<String, dynamic> json) {
    Map skin = json['textures']['SKIN'] ?? {},
        cape = json['textures']['CAPE'] ?? {};
    return ProfileTextures._()
      .._timestamp = json['timestamp']
      .._profileId = json['profileId']
      .._profileName = json['profileName']
      // .._signatureRequired = json['signatureRequired'] ?? false
      .._skinUrl = skin['url']
      .._capeUrl = cape['url'];
  }

  /// Get the Url for the skin of this player.
  /// If the player does not have a skin, this function will return "steve" or "alex".
  String getSkinUrl() {
    if (_skinUrl != null) {
      return _skinUrl;
    } else {
      /// There's no skin. The player is using the default Steve or Alex Skin.
      /// Minecraft uses [uuid.hashCode() & 1] for the Alex Skin.
      /// That can be compacted to counting the LSBs of every 4th byte in the Uuid.
      /// XOR-ing all the LSBs gives us 1 for alex and 0 for steve.
      var lsbs = int.parse(_profileId[7], radix: 16) ^
          int.parse(_profileId[15], radix: 16) ^
          int.parse(_profileId[23], radix: 16) ^
          int.parse(_profileId[31], radix: 16);
      // TODO: Maybe return the textures.minecraft.net URLs to the default skins?
      return lsbs.isOdd ? 'alex' : 'steve';
    }
  }

  /// Get the url to the cape texture.
  String getCapeUrl() => _capeUrl;

  /// Get the timestamp
  DateTime get getTimestamp => DateTime.fromMillisecondsSinceEpoch(_timestamp);

  /// Get the player's name
  String get getName => _profileName;
}

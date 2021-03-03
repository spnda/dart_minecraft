import 'dart:convert';

/// A Minecraft user including their skin/cape.
class Profile {
  final String _id;
  final String _name;
  final String _textures;
  final String _signatures;

  Profile.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'],
        _textures = json['properties'][0]['value'],
        _signatures = json['properties'][0]['signature'] ?? '';

  /// The UUID of this player.
  String get uuid => _id;

  /// This player's name.
  String get name => _name;

  /// Returns a ProfileTextures including this players' skin and cape textures.
  ProfileTextures get textures => ProfileTextures.fromJson(
      json.decode(utf8.decode(base64.decode(_textures))));

  /// This is a yggdrasil-server-only feature. It is basically useless towards a player or dev.
  String get signature => utf8.decode(base64.decode(_signatures));
}

/// The skin model of a texture
enum SkinModel { classic, slim }

/// Represents all textures for a minecraft profile.
class ProfileTextures {
  late int _timestamp;
  late String _profileId;
  late String _profileName;
  late String _skinUrl;
  late String _capeUrl;
  // bool _signatureRequired;

  late SkinModel _skinModel;

  ProfileTextures.fromJson(Map<String, dynamic> json) {
    Map skin = json['textures']['SKIN'] ?? {},
        cape = json['textures']['CAPE'] ?? {};
    this
      .._timestamp = json['timestamp']
      .._profileId = json['profileId']
      .._profileName = json['profileName']
      // .._signatureRequired = json['signatureRequired'] ?? false
      .._skinUrl = skin['url'] ?? ''
      .._skinModel = (skin['metadata'] ?? {})['model'] == 'slim'
          ? SkinModel.slim
          : SkinModel.classic
      .._capeUrl = cape['url'] ?? '';
  }

  /// Get the Url for the skin of this player.
  /// If the player does not have a skin, this function will return the link to the steve or alex skin.
  String getSkinUrl() {
    if (_skinUrl != '') {
      return _skinUrl;
    } else {
      /// There's no skin. The player is using the default Steve or Alex Skin.
      /// Minecraft uses [uuid.hashCode() & 1] for the Alex Skin.
      /// That can be compacted to counting the LSBs of every 4th byte in the Uuid.
      /// XOR-ing all the LSBs gives us 1 for alex and 0 for steve.
      /// See https://github.com/crafatar/crafatar/blob/9d2fe0c45424de3ebc8e0b10f9446e7d5c3738b2/lib/skins.js#L90-L108
      /// for the original implementation.
      var lsbs = int.parse(_profileId[7], radix: 16) ^
          int.parse(_profileId[15], radix: 16) ^
          int.parse(_profileId[23], radix: 16) ^
          int.parse(_profileId[31], radix: 16);
      return lsbs.isOdd
          ? 'http://assets.mojang.com/SkinTemplates/alex.png'
          : 'http://assets.mojang.com/SkinTemplates/steve.png';
      // return lsbs.isOdd ? 'alex' : 'steve';
    }
  }

  /// Get the url to the cape texture.
  String capeUrl() => _capeUrl;

  /// Get the timestamp
  DateTime get timestamp => DateTime.fromMillisecondsSinceEpoch(_timestamp);

  /// Get the player's name
  String get name => _profileName;

  /// Get the skin model of the skin.
  SkinModel get skinModel => _skinModel;
}

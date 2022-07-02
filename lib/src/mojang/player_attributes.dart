class PlayerAttributes {
  final Map<String, dynamic> _data;

  PlayerAttributes(Map<String, dynamic> data) : _data = data;

  bool hasPrivilege(String privilege) {
    return _data["privileges"][privilege]["enabled"] as bool;
  }

  bool get isProfanityFilterOn {
    return _data["profanityFilterPreferences"]["profanityFilterOn"] as bool;
  }

  // Returns a list of scope string (e.g. 'MULTIPLAYER') if this player is banned. Otherwise,
  // returns an empty list if the player is not banned.
  List<String> get banStatus {
    var scopes = _data["banStatus"]["bannedScopes"];
    if (scopes is Map<String, dynamic>) {
      return scopes.keys.toList();
    }
    return const [];
  }

  PlayerBan getBan(String id) {
    var scopes = _data["banStatus"]["bannedScopes"];
    if (scopes is! Map<String, dynamic> || !scopes.containsKey(id)) {
      throw ArgumentError();
    }
    return PlayerBan(scopes[id]);
  }

  static List<String> getPossibleBanReasons() {
    return const [
      "hate_speech",
      "terrorism_or_violent_extremism",
      "child_sexual_exploitation_or_abuse",
      "imminent_harm",
      "non_consensual_intimate_imagery",
      "harassment_or_bullying",
      "defamation_impersonation_false_information",
      "self_harm_or_suicide",
      "alcohol_tobacco_drugs"
    ];
  }
}

class PlayerBan {
  final String id;
  final int _expires;
  final String reason;
  final String reasonMessage;

  PlayerBan(Map<String, dynamic> data)
      : id = data["banId"],
        _expires = data["expires"],
        reason = data["reason"],
        reasonMessage = data["reasonMessage"];

  DateTime get getExpirationDate {
    return DateTime.fromMillisecondsSinceEpoch(_expires);
  }
}

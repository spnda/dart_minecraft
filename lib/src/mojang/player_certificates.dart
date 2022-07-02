class PlayerCertificates {
  final Map<String, dynamic> _data;

  PlayerCertificates(Map<String, dynamic> data) : _data = data;

  String get privateRsaKey {
    return _data["keyPair"]["privateKey"];
  }

  String get publicRsaKey {
    return _data["keyPair"]["publicKey"];
  }

  String get signature {
    return _data["publicKeySignature"];
  }

  DateTime get expiration {
    return DateTime.parse(_data["expiresAt"]);
  }

  DateTime get refreshed {
    return DateTime.parse(_data["expiresAt"]);
  }
}

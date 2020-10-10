/// A manifest of all currently available Minecraft Versions. Also has latest
/// release and snapshot versions.
class VersionManifest {
  String latestRelease, latestSnapshot;
  /// A list of all available versions.
  List<Version> versions;
  
  VersionManifest._();

  factory VersionManifest.fromJson(Map<String, dynamic> data) => VersionManifest._()
    ..latestRelease = data['latest']['release']
    ..latestSnapshot = data['latest']['snapshot']
    ..versions = data['versions'].map((Map<String, dynamic> d) => Version.fromJson(d));
}

/// A Minecraft Version.
class Version {
  String id, type, url, time, releaseTime;

  DateTime get getTime => DateTime.parse(time);
  DateTime get getReleaseTime => DateTime.parse(releaseTime);

  Version._();

  factory Version.fromJson(Map<String, dynamic> data) => Version._()
    ..id = data['id']
    ..type = data['type']
    ..url = data['url']
    ..time = data['time']
    ..releaseTime = data['releaseTime'];
}

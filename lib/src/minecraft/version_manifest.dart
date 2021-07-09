/// A manifest of all currently available Minecraft Versions. Also has latest
/// release and snapshot versions.
class VersionManifest {
  /// The latest available stable release of Minecraft: Java Edition.
  String latestRelease;

  /// The latest available beta snapshot of Minecraft: Java Edition.
  String latestSnapshot;

  /// A list of all available versions.
  List<Version> versions;

  VersionManifest.fromJson(Map<String, dynamic> data)
      : latestRelease = data['latest']['release'],
        latestSnapshot = data['latest']['snapshot'],
        versions = (data['versions'] as List<dynamic>)
            .map((d) => Version.fromJson(d))
            .toList();
}

/// A Minecraft Version.
class Version {
  /// The Minecraft Version ID, e.g. "1.16.3"
  String id;

  /// The type of this Minecraft Version, e.g. "snapshot" or "release";
  String type;

  /// The URL to the manifest of this version. This manifest includes
  /// libraries, command line arguments and more configuration for this
  /// version.
  String url;

  /// Some time that is usually just minutes after [releaseTime].
  String time;

  /// The time this version was release at.
  String releaseTime;

  /// A SHA1 hash of the version package.
  String sha1;

  /// The level of compliance of this client. Used to indicate
  /// version of player safety features.
  ///
  /// This value is 0 for all versions before 1.16.4-pre1,
  /// as those all do not include the so called "player
  /// safety features", and 1 for all versions since.
  int complianceLevel;

  /// Some time that is usually just minutes after [releaseTime]
  /// as a DateTime object.
  DateTime get timeDateTime => DateTime.parse(time);

  /// The time this version was release at as a DateTime object.
  DateTime get releaseDateTime => DateTime.parse(releaseTime);

  Version.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        url = data['url'],
        time = data['time'],
        releaseTime = data['releaseTime'],
        sha1 = data['sha1'],
        complianceLevel = data['complianceLevel'];
}

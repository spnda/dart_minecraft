/// A Name helper class used for [Mojang.getNameHistory()].
/// It contains the name and the date it was changed to.
class Name {
  final String _name;
  final int _changedToAt;

  /// Create a [Name] from a [name] String and a int value representing
  /// the unix timestamp at which the name was switched to.
  Name(this._name, this._changedToAt);

  /// Create a [Name] from JSON data.
  Name.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _changedToAt = json['changedToAt'] ?? 0;

  /// Returns the name.
  String get name => _name;

  /// Returns the date this name was set at.
  ///
  /// If this is the original Name for the player, this will default to `1970-01-01`.
  DateTime get changedAtDate =>
      DateTime.fromMillisecondsSinceEpoch(_changedToAt);

  /// Compares if two Names are equal.
  ///
  /// If compared with another instance of [Name], they will be compared by [_name] and [_changedToAt].
  @override
  bool operator ==(dynamic other) =>
      other is Name &&
      (other._name == _name && other._changedToAt == _changedToAt);

  @override
  int get hashCode => _name.hashCode;

  @override
  String toString() {
    return _name;
  }
}

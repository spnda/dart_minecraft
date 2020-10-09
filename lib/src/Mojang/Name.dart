class Name {
  String _name;
  int _changedToAt;

  Name._();

  factory Name(String name, int changedToAt) => Name._().._name = name.._changedToAt = changedToAt;

  factory Name.fromJson(Map<String, dynamic> json) => Name._()
    .._name = json['name']
    .._changedToAt = json['changedToAt'] ?? 0;

  String get getName => _name;

  /// Get's the date this name was set at.
  /// 
  /// If this is the original Name for the player, this will default to 1970-01-01.
  DateTime get getChangedAtDate => DateTime.fromMillisecondsSinceEpoch(_changedToAt);

  /// Compares if two Names or a Name and a String are equal.
  /// 
  /// If compared with a String, it will be compared with the [_name].
  /// If compared with another instance of [Name], they will be compared by [_name].
  @override
  bool operator ==(dynamic other) => other is Name && other._name == _name;

  @override
  int get hashCode => _name.hashCode;
}

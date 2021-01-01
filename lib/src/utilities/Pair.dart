/// Creates a pair of values.
class Pair<A, B> {
  final A _a;
  final B _b;

  Pair(this._a, this._b);

  A get getFirst => _a;

  B get getSecond => _b;

  @override
  int get hashCode => _a.hashCode ^ _b.hashCode;

  /// Compares a [Pair] with another Object.
  ///
  /// If [other] is a Pair and it's hashCode is the same as this'
  /// hashCode, the two are equal.
  /// If [other] is not a Pair, they are not equal.
  @override
  bool operator ==(dynamic other) =>
      other is Pair && (other._a == _a && other._b == _b);

  /// Combines [a] and [b] into a String, like "a, b".
  @override
  String toString() => '$_a, $_b';
}

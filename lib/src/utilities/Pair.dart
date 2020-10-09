/// Creates a pair of values.
class Pair<A, B> {
  final A _a;
  final B _b;

  Pair(this._a, this._b);

  A get getFirst => _a;

  B get getSecond => _b;

  @override
  int get hashCode => _a.hashCode ^ _b.hashCode;

  @override
  bool operator ==(dynamic other) => other is Pair && (other._a == _a && other._b == _b);

  @override
  String toString() => '$_a, $_b';
}

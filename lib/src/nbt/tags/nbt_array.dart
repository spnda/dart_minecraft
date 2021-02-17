import 'dart:collection';

import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_tags.dart';

/// The base of any array or list nbt tag. Uses the [ListMixin] 
/// to inherit all methods and properties of a [List].
abstract class NbtArray<T> extends NbtTag with ListMixin<T> {
  final List<T> children = <T>[];

  NbtArray(NbtTag parent, NbtTagType nbtTagType) : super(parent, nbtTagType);

  @override
  List<T> get value => children;

  @override
  int get length => children.length;

  @override
  set length(int length) => children.length = length;

  @override
  T operator [](int index) => children[index];

  @override
  void operator []=(int index, T value) {
    children[index] = value;
  }
  
  @override
  String toString() {
    return '${nbtTagType.asString()}($name): ${children.length} entries {$value}';
  }
}

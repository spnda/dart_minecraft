import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/src/nbt/nbt_compression.dart';
import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_byte_array.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_compound.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_int.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_list.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_string.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';
import 'package:test/test.dart';

bool compareFiles(String file1, String file2) {
  final contents1 = File(file1).readAsBytesSync();
  final contents2 = File(file2).readAsBytesSync();
  return const ListEquality().equals(contents1, contents2);
}

void main() {
  test('Read servers.dat', () async {
    final nbtFile = NbtFile.fromPath('./test/servers.dat');
    // As we have not yet called [readFile], the root node should be null.
    expect(nbtFile.root, isNull);

    await nbtFile.readFile();
    final root = nbtFile.root;
    expect(root, isNot(null));

    /// The root tag should always be a Compound for Java Edition NBT.
    expect(root.nbtTagType, equals(NbtTagType.TAG_COMPOUND));

    /// As we're checking the servers.dat file, the root compound only 
    /// has a single child, a TAG_List with the name 'servers'.
    expect(root.getChildrenByName('servers').length, equals(1));
  });

  test('Read bigtest.nbt', () async {
    // bigtest.nbt is GZIP compressed and is therefore a special test file.
    // You can get bigtest.nbt from https://raw.github.com/Dav1dde/nbd/master/test/bigtest.nbt.
    final nbtFile = NbtFile.fromPath('./test/bigtest.nbt');
    await nbtFile.readFile();
    final root = nbtFile.root;
    expect(root, isNot(null));

    expect(root.getChildrenByName('stringTest').first.value, equals('HELLO WORLD THIS IS A TEST STRING ÅÄÖ!'));

    expect((root.getChildrenByName('byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))').first as NbtByteArray).length, equals(1000));
  });

  test('Read level.dat', () async {
    // level.dat is simply any main minecraft world file.
    final nbtFile = NbtFile.fromPath('./test/level.dat');
    await nbtFile.readFile();
    final root = nbtFile.root;
    expect(root, isNot(null));

    final list = (root.children.first as NbtList).where((val) => val.nbtTagType == NbtTagType.TAG_STRING);

    // We'll check that there should be at max 3 TAG_Strings in the list.
    // These strings are named "generatorName", "WanderingTraderId" and "LevelName".
    expect(list.length, inInclusiveRange(1, 3));
  });

  test('Read NaN double value', () async {
    // Player-nan-value.dat is a NBT file with a TAG_Double with a NaN (Not a Number).
    // It's also 
    // This checks if the parser can detect this issue and handles the value accordingly.
    final nbtFile = NbtFile.fromPath('./test/NaN-value.nbt');
    await nbtFile.readFile();

    // 'Pos' is a NbtList, where the second entry is a NaN. Check if that value exists there and if it is NaN.
    // TAG_List(Pos): 3 entries {[TAG_Double(None): 0.0, TAG_Double(None): NaN, TAG_Double(None): 0.0]}
    final fallDistance = nbtFile.root.getChildrenByName('Pos').first;

    // [fallDistance] should be a NbtList<NbtDouble>, but as NbtList<T> can be anything, we will only check
    // if it is NbtList<NbtTag>.
    expect(fallDistance, isA<NbtList<NbtTag>>());

    // The second child should be a NbtDouble and have a NaN value.
    expect((fallDistance as NbtList<NbtTag>).children[1].value, isNaN);
  });

  test('Rewrite servers.dat', () async {
    final nbtFile = NbtFile.fromPath('./test/servers.dat');
    await nbtFile.readFile();

    await nbtFile.writeFile(file: File('./test/servers2.dat'), nbtCompression: nbtFile.compression);

    expect(compareFiles('./test/servers.dat', './test/servers2.dat'), isTrue);
  });

  test('Rewrite bigtest.dat', () async {
    final nbtFile = NbtFile.fromPath('./test/bigtest.nbt');
    await nbtFile.readFile();

    await nbtFile.writeFile(file: File('./test/bigtest2.nbt'), nbtCompression: nbtFile.compression);

    expect(compareFiles('./test/bigtest.nbt', './test/bigtest2.nbt'), isTrue);
  });

  test('Rewrite level.dat', () async {
    final nbtFile = NbtFile.fromPath('./test/level.dat');
    await nbtFile.readFile();

    await nbtFile.writeFile(file: File('./test/level2.dat'), nbtCompression: nbtFile.compression);

    expect(compareFiles('./test/level.dat', './test/level2.dat'), isTrue);

    // Re-read the file and check if they're identical
    final nbtFile2 = NbtFile.fromPath('./test/level2.dat');
    await nbtFile2.readFile();
    expect(nbtFile2.root.last, isTrue);
  });

  test('Write test.nbt', () async {
    final nbtFile = NbtFile.fromPath('./test/test.nbt');
    nbtFile.root = NbtCompound(
      name: 'rootCompound',
      children: <NbtTag>[
        NbtInt(
          name: 'intTest',
          value: 5430834,
        ),
        NbtString(
          name: 'stringTest',
          value: 'This is a String test!'
        ),
      ],
    );

    // Write the data to the file.
    await nbtFile.writeFile(nbtCompression: NbtCompression.gzip);

    // Re-read the file from disk.
    await nbtFile.readFile();

    expect(nbtFile.root.children[0].value, equals(5430834));
    expect(nbtFile.root.children[1].value, equals('This is a String test!'));
  });
}

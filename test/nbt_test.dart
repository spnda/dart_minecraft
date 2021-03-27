import 'dart:io';

import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/src/exceptions/nbt_exception.dart';
import 'package:dart_minecraft/src/exceptions/nbt_file_write_exception.dart';
import 'package:test/test.dart';

void main() {
  group('Read files and check for values', () {
    test('Read servers.dat', () async {
      final nbtFile = NbtFile.fromPath('./test/servers.dat');
      // As we have not yet called [readFile], the root node should be null.
      expect(nbtFile.root, isNull);

      try {
        await nbtFile.readFile();
      } on NbtException catch (e) {
        print(e);
        return;
      }
      final root = nbtFile.root;
      expect(root, isNotNull);

      /// The root tag should always be a Compound for Java Edition NBT.
      expect(root!.nbtTagType, equals(NbtTagType.TAG_COMPOUND));

      /// As we're checking the servers.dat file, the root compound only
      /// has a single child, a TAG_List with the name 'servers'.
      expect(root.getChildrenByName('servers').length, equals(1));
    });

    test('Read bigtest.nbt', () async {
      // bigtest.nbt is GZIP compressed and is therefore a special test file.
      // You can get bigtest.nbt from https://raw.github.com/Dav1dde/nbd/master/test/bigtest.nbt.
      final nbtFile = NbtFile.fromPath('./test/bigtest.nbt');
      try {
        await nbtFile.readFile();
      } on NbtException catch (e) {
        print(e);
        return;
      }
      final root = nbtFile.root;
      expect(root, isNotNull);

      expect(root!.getChildrenByName('stringTest').first.value,
          equals('HELLO WORLD THIS IS A TEST STRING ÅÄÖ!'));

      final nbtByteArray = root
          .getChildrenByName(
              'byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))')
          .first as NbtByteArray;

      expect(nbtByteArray.length, equals(1000));
    });

    test('Read level.dat', () async {
      // level.dat is simply any main minecraft world file.
      final nbtFile = NbtFile.fromPath('./test/level.dat');
      try {
        await nbtFile.readFile();
      } on NbtException catch (e) {
        print(e);
        return;
      }
      final root = nbtFile.root;
      expect(root, isNotNull);

      final list = (root!.children.first as NbtList)
          .where((val) => val.nbtTagType == NbtTagType.TAG_STRING);

      // We'll check that there should be at max 3 TAG_Strings in the list.
      // These strings are named "generatorName", "WanderingTraderId" and "LevelName".
      expect(list.length, inInclusiveRange(1, 3));
    });

    test('Read NaN double value', () async {
      // Player-nan-value.dat is a NBT file with a TAG_Double with a NaN (Not a Number).
      // This checks if the parser can detect this issue and handles the value accordingly.
      final nbtFile = NbtFile.fromPath('./test/NaN-value.nbt');
      try {
        await nbtFile.readFile();
      } on NbtException catch (e) {
        print(e);
        return;
      }

      expect(nbtFile.root, isNotNull);

      // 'Pos' is a NbtList, where the second entry is a NaN. Check if that
      // value exists there and if it is NaN.
      // TAG_List(Pos): 3 entries {[TAG_Double(None): 0.0, TAG_Double(None): NaN, TAG_Double(None): 0.0]}
      final fallDistance = nbtFile.root!.getChildrenByName('Pos').first;

      // [fallDistance] should be a NbtList<NbtDouble>, but as NbtList<T> can be
      // anything, we will only check if it is NbtList<NbtTag>.
      expect(fallDistance, isA<NbtList<NbtTag>>());

      // The second child should be a NbtDouble and have a NaN value.
      expect((fallDistance as NbtList<NbtTag>).children[1].value, isNaN);
    });
  });

  group('Rewrite files and check if they remain the same.', () {
    Future<bool> compareFiles(String file, String file2) async {
      final nbtFile1 = NbtFile.fromPath(file);
      await nbtFile1.readFile();
      final nbtFile2 = NbtFile.fromPath(file2);
      await nbtFile2.readFile();
      return nbtFile1.root == nbtFile2.root;
    }

    test('Rewrite servers.dat', () async {
      try {
        final nbtFile = NbtFile.fromPath('./test/servers.dat');
        await nbtFile.readFile();

        await nbtFile.writeFile(
            file: File('./test/servers2.dat'),
            nbtCompression: nbtFile.compression ?? NbtCompression.none);

        expect(await compareFiles('./test/servers.dat', './test/servers2.dat'),
            isTrue);
      } on NbtException catch (e) {
        print(e);
      }
    });

    test('Rewrite bigtest.dat', () async {
      var nbtFile = NbtFile.fromPath('./test/bigtest.nbt');
      try {
        await nbtFile.readFile();

        await nbtFile.writeFile(
            file: File('./test/bigtest2.nbt'),
            nbtCompression: nbtFile.compression ?? NbtCompression.none);

        await nbtFile.readFile(file: File('./test/bigtest2.nbt'));

        expect(await compareFiles('./test/bigtest.nbt', './test/bigtest2.nbt'),
            isTrue);
      } on NbtException catch (e) {
        print(e);
      }
    });

    test('Rewrite level.dat', () async {
      final nbtFile = NbtFile.fromPath('./test/level.dat');
      try {
        await nbtFile.readFile();

        await nbtFile.writeFile(
            file: File('./test/level2.dat'),
            nbtCompression: nbtFile.compression ?? NbtCompression.none);

        expect(
            await compareFiles('./test/level.dat', './test/level2.dat'), isTrue);
      } on NbtException catch (e) {
        print(e);
      }
    });
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
        NbtString(name: 'stringTest', value: 'This is a String test!'),
      ],
    );

    try {
      // Write the data to the file.
      await nbtFile.writeFile(nbtCompression: NbtCompression.gzip);

      // Re-read the file from disk.
      await nbtFile.readFile();

      expect(nbtFile.root, isNotNull);
      expect(nbtFile.root!.children[0].value, equals(5430834));
      expect(nbtFile.root!.children[1].value, equals('This is a String test!'));
    } on NbtException catch (e) {
      print(e);
    }
  });
}

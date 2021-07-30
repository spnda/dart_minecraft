import 'dart:io';
import 'dart:typed_data';

Uint8List fromFile(String path) => File(path).readAsBytesSync();

Future<void> toFile(String path, List<int> data) async =>
    File(path).writeAsBytes(data);

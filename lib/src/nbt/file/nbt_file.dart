import 'dart:typed_data';

Uint8List fromFile(String path) =>
    throw UnsupportedError('dart:io is required to parse files.');

Future<void> toFile(String path, List<int> data) async =>
    throw UnsupportedError('dart:io is required to write files.');

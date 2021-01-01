import 'package:test/test.dart';

String getDefaultSkin() {
  final uuid = '4b732d33f73445f797df125ea2f7f6e2';
  final lsbs = int.parse(uuid[7], radix: 16) ^
      int.parse(uuid[15], radix: 16) ^
      int.parse(uuid[23], radix: 16) ^
      int.parse(uuid[31], radix: 16);
  return lsbs.isOdd ? 'alex' : 'steve';
}

void main() {
  test('This function should determine steve or alex Skin.', () {
    expect(getDefaultSkin(), 'alex');
  });
}

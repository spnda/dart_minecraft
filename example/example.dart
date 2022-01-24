import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/dart_nbt.dart';

Future<int> main() async {
  /// In this example we'll read content from a NBT File
  /// which in its root compound has a single NbtString that
  /// contains a UUID of a player we'll try and get the skin texture from.
  final nbtReader = NbtReader.fromFile('./example/data.nbt');
  try {
    nbtReader.read();
  } on NbtFileReadException {
    print('Failed to read data.nbt');
  }

  /// If the file doesn't exist we'll instead use some example data.
  /// This shows how one would create nbt data using this package.
  nbtReader.root ??= NbtCompound(
    name: '',
    children: [
      NbtString(
        name: 'uuid',
        value: '069a79f444e94726a5befca90e38aaf5', // This is Notch's UUID.
      ),
    ],
  );

  final nbtString = nbtReader.root!.first as NbtString?;

  /// Now with our UUID, we can get the profile of given UUID.
  /// This will allow us to get their profile, which contains the
  /// textures.
  if (nbtString == null) return -1;
  final profile = await getProfile(nbtString.value);
  final skins = profile.getSkins;
  if (skins.isEmpty) return -1;

  final skinUrl = skins.first.url;
  print("Notch's Skin URL: $skinUrl"); // URL to Notch's skin texture.

  /// As we've now got the URL for the texture, we'll write the link to
  /// it to our previously read nbt file and re-write it to the file.
  final compound = nbtReader.root!;
  compound.removeWhere((tag) => tag.name == 'skinUrl');
  compound.add(NbtString(name: 'skinUrl', value: skinUrl));

  // Here, you can also use NbtCompression to compress the output.
  await NbtWriter().writeFile('./example/data.nbt', compound);
  return 0;
}

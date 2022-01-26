/// The NBT library for reading and writing the so called
/// "Named Binary Tag" file format. Minecraft world files
/// and other storage files related to Minecraft: Java Edition
/// are stored in this file format.
/// 
/// The format allows for compression with gzip or zlib. However,
/// using dart2js will currently lead to exceptions while reading
/// or writing as the platform does not include a implementation
/// of the afformentioned compression algorithmns.
library nbt;

export 'src/exceptions/nbt_file_read_exception.dart';
export 'src/exceptions/nbt_file_write_exception.dart';
export 'src/nbt/nbt_compression.dart';
export 'src/nbt/nbt_reader.dart';
export 'src/nbt/nbt_tags.dart';
export 'src/nbt/nbt_writer.dart';
export 'src/nbt/tags/nbt_array.dart';
export 'src/nbt/tags/nbt_byte.dart';
export 'src/nbt/tags/nbt_byte_array.dart';
export 'src/nbt/tags/nbt_compound.dart';
export 'src/nbt/tags/nbt_double.dart';
export 'src/nbt/tags/nbt_float.dart';
export 'src/nbt/tags/nbt_int.dart';
export 'src/nbt/tags/nbt_int_array.dart';
export 'src/nbt/tags/nbt_list.dart';
export 'src/nbt/tags/nbt_long.dart';
export 'src/nbt/tags/nbt_long_array.dart';
export 'src/nbt/tags/nbt_short.dart';
export 'src/nbt/tags/nbt_string.dart';
export 'src/nbt/tags/nbt_tag.dart';

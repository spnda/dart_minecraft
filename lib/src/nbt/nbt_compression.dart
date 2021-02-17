/// The compression of a [NbtFile].
/// Gzip compressed files usually start with 1F.
/// Zlib compressed files usually start with 78.
/// Implementation of detecting the compression can be found 
/// at [NbtFileReader#detectCompression].
enum NbtCompression {
  NONE,
  GZIP,
  ZLIB,
  UNKNOWN,
}

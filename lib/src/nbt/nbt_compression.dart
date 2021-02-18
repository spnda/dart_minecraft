/// The compression of a [NbtFile].
/// Implementation of detecting the compression can be found 
/// at [NbtFileReader#detectCompression].
enum NbtCompression {
  /// The file does not have any compression.
  none,

  /// Gzip compressed files usually start with 1F.
  gzip,

  /// Zlib compressed files usually start with 78.
  zlib,

  /// There was an error reading the compression.
  unknown,
}

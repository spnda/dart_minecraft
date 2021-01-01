/// A Patch/Version of Minecraft, including a image and a description.
class MinecraftPatch {
  /// The title of this patch.
  String title;

  /// The type of this patch, e.g. "release" or "snapshot".
  String type;

  /// The actual version id of this patch.
  String version;

  /// A string id of this version.
  String id;

  /// The shortened url to the patch's image.
  /// Can be properly obtained from [getImageUrl].
  String _imageUrl;

  /// The title of this patch's image.
  String imageTitle;

  /// A html style description of this patch.
  String body;

  MinecraftPatch._();

  factory MinecraftPatch.fromJson(Map<String, dynamic> data) =>
      MinecraftPatch._()
        ..title = data['title']
        ..type = data['type']
        ..version = data['version']
        ..body = data['body']
        ..id = data['id']
        .._imageUrl = data['image']['url']
        ..imageTitle = data['image']['title'];

  /// The url to the patch's image.
  String get getImageUrl => 'https://launchercontent.mojang.com/' + _imageUrl;
}

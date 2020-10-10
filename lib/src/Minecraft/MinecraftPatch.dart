/// A Patch/Version of Minecraft, including a image and a description.
class MinecraftPatch {
  String title, type, version, id, _imageUrl, imageTitle;

  /// A html style description of this patch.
  String body;

  MinecraftPatch._();

  factory MinecraftPatch.fromJson(Map<String, dynamic> data) => MinecraftPatch._()
    ..title = data['title']
    ..type = data['type']
    ..version = data['version']
    ..body = data['body']
    ..id = data['id']
    .._imageUrl = data['image']['url']
    ..imageTitle = data['image']['title'];
    
  String get getImageUrl => 'https://launchercontent.mojang.com/' + _imageUrl;
}

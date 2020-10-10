/// A Minecraft News item.
class MinecraftNews {
  String title, description, url, id, _imageUrl;
  bool forDemoUsersOnly = false;

  MinecraftNews._();

  factory MinecraftNews.fromJson(Map<String, dynamic> data) => MinecraftNews._()
    ..title = data['title']
    ..description = data['description']
    ..url = data['url']
    ..id = data['id']
    .._imageUrl = data['image']['url']
    ..forDemoUsersOnly = data['forDemoUsersOnly'] ?? false;

  /// Get's the url to the image of this news item. News images are
  /// usually 1200x512 pixels in size.
  String get getImageUrl => 'https://launchercontent.mojang.com/' + _imageUrl;
}

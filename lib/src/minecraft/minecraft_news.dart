/// A Minecraft News item.
class MinecraftNews {
  /// The title of this news item.
  String title;

  /// The description of this news. Formatted in HTML.
  String description;

  /// The url to this news article on https://minecraft.net.
  String url;

  /// The id of this news item.
  String id;

  /// The shortened url to the patch's image.
  /// Can be properly obtained from [getImageUrl].
  final String _imageUrl;

  /// If this news item is only for demo users who do not own the game.
  bool forDemoUsersOnly;

  MinecraftNews.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        url = data['url'],
        id = data['id'],
        _imageUrl = data['image']['url'],
        forDemoUsersOnly = data['forDemoUsersOnly'] ?? false;

  /// Get's the url to the image of this news item. News images are
  /// usually 1200x512 pixels in size.
  String get imageUrl => 'https://launchercontent.mojang.com/$_imageUrl';
}

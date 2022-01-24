/// A Minecraft News item.
class MinecraftNews {
  /// The title of this news item.
  final String title;

  final String tag;

  /// The category of this news article, e.g. "Minecraft: Java Edition"
  final String category;

  /// The date on which this news article was published.
  final String _date;

  /// The description of this news. Formatted in HTML.
  final String text;

  /// The url to this news article on https://minecraft.net.
  final String url;

  /// The id of this news item.
  final String id;

  final bool important;

  /// The shortened url to the patch's image.
  /// Can be properly obtained from [getImageUrl].
  final String _imageUrl;

  MinecraftNews.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        tag = data.containsKey('tag') ? data['tag'] : '',
        category = data['category'],
        _date = data['date'],
        text = data['text'],
        url = data['readMoreLink'],
        id = data['id'],
        _imageUrl = data['newsPageImage']['url'],
        important = data.containsKey('cardBorder') ? data['cardBorder'] : false;

  /// Get's the url to the image of this news item. News images are
  /// usually 1200x512 pixels in size.
  String get imageUrl => 'https://launchercontent.mojang.com/$_imageUrl';

  /// Get's the date at which this article was published.
  /// Note that this is always at midnight, as the original
  /// timestamp does not provide any hours/minutes.
  DateTime get date => DateTime.parse(_date);
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Web utilities for making HTTP requests
class WebUtil {
  static final HttpClient _client = HttpClient();

  /// HTTP GET request.
  static Future<HttpClientResponse> get(String base, String api) async {
    if (!base.endsWith('/')) base += '/';
    final request = await _client.getUrl(Uri.parse('$base$api'));
    return request.close();
  }

  /// HTTP POST request.
  static Future<HttpClientResponse> post(String base, String api, dynamic body, Map<String, dynamic> headers) async {
    if (!base.endsWith('/')) base += '/';
    if (!(body is List) && !(body is Map)) throw Exception('body must be a List or Map');
    final request = await _client.postUrl(Uri.parse('$base$api'));
    for (MapEntry e in headers.entries) {
      request.headers.add(e.key, e.value);
    }
    return request.close();
  }

  /// Parses the `response`'s body into a Map<String, dynamic> or List<dynamic>.
  static Future<dynamic> getJsonFromResponse(HttpClientResponse response) {
    final contents = StringBuffer();
    final completer = Completer<dynamic>();
    response.transform(utf8.decoder).listen(
      (data) => contents.write(data), 
      onDone: () => completer.complete(json.decode(contents.toString()))
    );
    return completer.future;
  }
}
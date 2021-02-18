import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: avoid_classes_with_only_static_members
/// Web utility for making HTTP requests
class WebUtil {
  static final HttpClient _client = HttpClient();

  /// HTTP GET request.
  static Future<HttpClientResponse> get(String base, String api) async {
    if (!base.endsWith('/')) base += '/';
    final request = await _client.getUrl(Uri.parse('$base$api'));
    return request.close();
  }

  /// HTTP POST request.
  static Future<HttpClientResponse> post(String base, String api, dynamic body, [Map<String, dynamic> headers = const {}]) async {
    if (!base.endsWith('/')) base += '/';
    if (!(body is List) && !(body is Map)) {
      throw Exception('body must be a List or Map');
    }
    final request = await _client.postUrl(Uri.parse('$base$api'));
    for (MapEntry e in headers.entries) {
      request.headers.add(e.key, e.value);
    }
    request.add(utf8.encode(json.encode(body)));
    return request.close();
  }

  /// HTTP PUT request.
  static Future<HttpClientResponse> put(String base, String api, dynamic body, [Map<String, dynamic> headers = const {}]) async {
    if (!base.endsWith('/')) base += '/';
    final request = await _client.putUrl(Uri.parse('$base$api'));
    for (MapEntry e in headers.entries) {
      request.headers.add(e.key, e.value);
    }
    request.add(utf8.encode(json.encode(body)));
    return request.close();
  }

  /// HTTP DELETE request.
  static Future<HttpClientResponse> delete(String base, String api, [Map<String, dynamic> headers = const {}]) async {
    if (!base.endsWith('/')) base += '/';
    final request = await _client.deleteUrl(Uri.parse('$base$api'));
    for (MapEntry e in headers.entries) {
      request.headers.add(e.key, e.value);
    }
    return request.close();
  }

  /// Get's the payload of given [response] and returns it as a String.
  static Future<String> getResponseBody(HttpClientResponse response) {
    final contents = StringBuffer();
    final completer = Completer<String>();
    response.transform(utf8.decoder).listen(
          contents.write,
          onDone: () => completer.complete(contents.toString()),
        );
    return completer.future;
  }

  /// Parses the [response]'s body into a Map<String, dynamic> or List<dynamic>.
  static Future<dynamic> getJsonFromResponse(HttpClientResponse response) async {
    var body = await getResponseBody(response);
    if (body.isEmpty) return null; // Avoid throwing errors in json.decode
    return json.decode(body);
  }
}

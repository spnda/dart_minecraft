import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

typedef HttpRequestFunction = Future<http.Response> Function(Uri url,
    {Map<String, String>? headers});
typedef HttpRequestBodyFunction = Future<http.Response> Function(Uri url,
    {Map<String, String>? headers, Object? body, Encoding? encoding});

/// Quick and easy function to call a HTTP request using any function
/// from the http package. Uses [Uri.https] to combine the Uri.
Future<http.Response> request(HttpRequestFunction func, String base, String api,
    {Map<String, String> headers = const {}}) {
  return func(Uri.https(base, api), headers: headers);
}

/// Quick and easy function to call a HTTP request using any function
/// from the http package that uses a body. Uses [Uri.https] to
/// combine the Uri.
Future<http.Response> requestBody(
    HttpRequestBodyFunction func, String base, String api, dynamic body,
    {Map<String, String> headers = const {}}) {
  return func(Uri.https(base, api),
      body: (headers.containsValue('application/json'))
          ? json.encode(body)
          : body,
      headers: headers);
}

Map<String, dynamic> parseResponseMap(http.Response response) {
  final map = json.decode(response.body);
  if (map is! Map<String, dynamic>) {
    throw Exception(
        'Content returned from the server is in an unexpected format.');
  } else {
    return map;
  }
}

List<dynamic> parseResponseList(http.Response response) {
  final list = json.decode(response.body);
  if (list is! List) {
    throw Exception(
        'Content returned from the server is in an unexpected format.');
  } else {
    return list;
  }
}

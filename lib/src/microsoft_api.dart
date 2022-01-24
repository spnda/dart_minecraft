import 'dart:async';

import 'package:http/http.dart' as http;

import 'utilities/pair.dart';
import 'utilities/web_util.dart';

typedef XboxToken = Pair<String, String>;

const String _xstsAuth = 'xsts.auth.xboxlive.com';

Future<XboxToken> authenticateXSTS(String xblToken) async {
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  final response = await requestBody(
      http.post,
      _xstsAuth,
      'xsts/authorize',
      {
        'Properties': {
          'SandboxId': 'RETAIL',
          'UserTokens': [
            xblToken,
          ],
        },
        'RelyingParty': 'rp://api.minecraftservices.com/',
        'TokenType': 'JWT'
      },
      headers: headers);

  final map = parseResponseMap(response);
  if (map.containsKey('XErr')) {
    switch (map['XErr'] as int) {
      case 2148916233:
        throw Exception(
            'The Microsoft account does not have a linked XBOX account');
      case 2148916235:
        throw Exception(
            'XBOX Live is not available in the account\'s country.');
      case 2148916238:
        throw Exception(
            'The accounts owner is a child and cannot proceed without verification of an adult.');
    }
  } else if (map.containsKey('Message')) {
    throw Exception(map['Message']);
  }

  assert(map.containsKey('Token'));
  String xstsToken = map['Token'];
  String userHash = map['DisplayClaims']['xui'][0]['uhs']; // Check this?
  return XboxToken(xstsToken, userHash); // The XSTS Token.
}

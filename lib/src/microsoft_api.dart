import 'dart:async';

import 'package:http/http.dart' as http;

import 'exceptions/auth_exception.dart';
import 'utilities/pair.dart';
import 'utilities/web_util.dart';

typedef XboxToken = Pair<String, String>;

const String _xblAuth = 'user.auth.xboxlive.com';
const String _xstsAuth = 'xsts.auth.xboxlive.com';

/// Authenticate with XBOX Live. This requires a previously
/// acquired Microsoft Access Token. A Microsoft Access Token is
/// acquired by following through the
/// [Microsoft Authentication Scheme](https://wiki.vg/Microsoft_Authentication_Scheme).
/// To be specific, this function requires the `access_token` from
/// the login.live.com/oauth20_token.srf endpoint.
Future<XboxToken> authenticateXBL(String msAccessToken) async {
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  final response = await requestBody(
      http.post,
      _xblAuth,
      'user/authenticate',
      {
        'Properties': {
          'AuthMethod': 'RPS',
          'SiteName': 'user.auth.xboxlive.com',
          'RpsTicket': 'd=$msAccessToken',
        },
        'RelyingParty': 'http://auth.xboxlive.com',
        'TokenType': 'JWT'
      },
      headers: headers);

  if (response.statusCode == 401) {
    throw AuthException('Microsoft token expired or is not correct');
  }

  final map = parseResponseMap(response);
  assert(map.containsKey('Token'));
  String xstsToken = map['Token'];
  String userHash =
      map['DisplayClaims']['xui'][0]['uhs']; // Check if this value is valid?
  return XboxToken(xstsToken, userHash);
}

/// Retrieves a XBOX Live Security token for the XBOX Live
/// token. The XBOX Live token can be acquired using [authenticateXBL].
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

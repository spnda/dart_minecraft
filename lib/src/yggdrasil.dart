import 'package:uuid/uuid.dart';

import 'exceptions/auth_exception.dart';
import 'mojang/mojang_account.dart';
import 'utilities/web_util.dart';

class Yggdrasil {
  static const String _authserver = 'https://authserver.mojang.com/';

  /// Authenticates a user with given credentials [username] and [password].
  static Future<MojangAccount> authenticate(String username, String password) async {
    final payload = {
      'agent': {'name': 'Minecraft', 'version ': 1},
      'username': username,
      'password': password,
      'clientToken': Uuid().v4(),
      'requestUser': true
    };
    final response =
        await WebUtil.post(_authserver, 'authenticate', payload, {});
    final data = await WebUtil.getJsonFromResponse(response);
    if (data['error'] != null) throw AuthException(data['errorMessage']);
    return MojangAccount.fromJson(data);
  }

  /// Refreshes the [account]. The [account] data will be overriden with the new 
  /// refreshed data. The return value is also the same [account] object.
  static Future<MojangAccount> refresh(MojangAccount account) async {
    final payload = {
      'accessToken': account.accessToken,
      'clientToken': account.clientToken,
      'selectedProfile': {
        'id': account.selectedProfile.id,
        'name': account.selectedProfile.name,
      },
      'requestUser': true,
    };
    final response = await WebUtil.post(_authserver, 'refresh', payload, {});
    final data = await WebUtil.getJsonFromResponse(response);
    if (data['error'] != null) {
      switch (data['error']) {
        case 'ForbiddenOperationException':
          throw AuthException(AuthException.invalidCredentialsMessage);
        default:
          throw Exception(data['errorMessage']);
      }
    }

    // Insert the data into our old account object.
    account
      ..accessToken = data['accessToken']
      ..clientToken = data['clientToken'];
    if (data['selectedProfile'] != null) {
      account.selectedProfile
        ..id = data['selectedProfile']['id']
        ..name = data['selectedProfile']['name'];
    }
    if (data['user'] != null) {
      account.user
        ..id = data['user']['id']
        ..preferredLanguage = (data['user']['properties'] as List)
            .where((f) => (f as Map)['name'] == 'preferredLanguage')
            .first
        ..twitchOAuthToken = (data['user']['properties'] as List)
            .where((f) => (f as Map)['name'] == 'twitch_access_token')
            .first;
    }

    return account;
  }

  /// Checks if given [accessToken] and [clientToken] are still valid.
  ///
  /// [clientToken] is optional, though if provided should match the client token
  /// that was used to obtained given [accessToken].
  static Future<bool> validate(String accessToken, {String? clientToken}) async {
    final payload = {
      'accessToken': accessToken,
    };
    if (clientToken != null) {
      payload.putIfAbsent('clientToken', () => clientToken);
    }
    final response = await WebUtil.post(_authserver, 'validate', payload, {});
    return response.statusCode == 204;
  }

  /// Signs the user out and invalidates the accessToken.
  static Future<bool> signout(String username, String password) async {
    final payload = {
      'username': username,
      'password': password,
    };
    final response = await WebUtil.post(_authserver, 'signout', payload, {});
    final data = await WebUtil.getResponseBody(response);
    return data.isEmpty;
  }

  /// Invalidates the accessToken of given [mojangAccount].
  static Future<bool> invalidate(MojangAccount mojangAccount) async {
    final payload = {
      'accessToken': mojangAccount.accessToken,
      'clientToken': mojangAccount.clientToken,
    };
    final response = await WebUtil.post(_authserver, 'invalidate', payload, {});
    final data = await WebUtil.getResponseBody(response);
    return data.isEmpty;
  }
}

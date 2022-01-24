import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'exceptions/auth_exception.dart';
import 'mojang/mojang_account.dart';
import 'utilities/web_util.dart';

const String _mojangApi = 'api.mojang.com';
const String _authServerApi = 'authserver.mojang.com';

/// Authenticates a user with given credentials [username] and [password].
/// This *only* works with Mojang accounts and does not work with
/// migrated Microsoft accounts.
///
/// [clientToken] should be identical for each request, otherwise old
/// access tokens will be invalidated. If omitted, a randomly generated
/// version 4 UUID will be used.
Future<MojangAccount> authenticate(String username, String password,
    {String? clientToken}) async {
  final payload = {
    'agent': {'name': 'Minecraft', 'version ': 1},
    'username': username,
    'password': password,
    'clientToken': clientToken ?? Uuid().v4(),
    'requestUser': true
  };
  final response = await requestBody(
      http.post, _authServerApi, 'authenticate', payload,
      headers: {'content-type': 'application/json'});
  final data = parseResponseMap(response);
  if (data['error'] != null) {
    if (response.statusCode == 403) {
      throw AuthException(data['errorMessage']);
    } else if (response.statusCode == 400) {
      throw ArgumentError('Invalid username, password or client token.');
    } else if (data['error'] == 'GoneException') {
      // The account was migrated to a Microsoft account.
      throw Exception('The account has been migrated to a Microsoft account.');
    } else {
      throw Exception(data['errorMessage']);
    }
  }
  return MojangAccount.fromJson(data);
}

/// Refreshes the [account]. The [account] data will be overridden with the new
/// refreshed data. The return value is also the same [account] object.
Future<MojangAccount> refresh(MojangAccount account) async {
  final payload = {
    'accessToken': account.accessToken,
    'clientToken': account.clientToken,
    'selectedProfile': {
      'id': account.selectedProfile.id,
      'name': account.selectedProfile.name,
    },
    'requestUser': true,
  };
  final response = await requestBody(
      http.post, _authServerApi, 'refresh', payload,
      headers: {});
  final data = parseResponseMap(response);
  if (data['error'] != null) {
    switch (data['error']) {
      case 'ForbiddenOperationException':
        throw AuthException(AuthException.invalidCredentialsMessage);

      /// Throws when access or client token are invalid / already in use.
      case 'IllegalArgumentException':
        throw ArgumentError(data['errorMessage']);
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
Future<bool> validate(String accessToken, {String? clientToken}) async {
  final headers = {
    'content-type': 'application/json',
  };
  final payload = {
    'accessToken': accessToken,
  };
  if (clientToken != null) {
    payload.putIfAbsent('clientToken', () => clientToken);
  }

  final response = await requestBody(
      http.post, _authServerApi, 'validate', payload,
      headers: headers);
  return response.statusCode == 204;
}

/// Signs the user out and invalidates the accessToken.
Future<bool> signout(String username, String password) async {
  final payload = {
    'username': username,
    'password': password,
  };
  final response = await requestBody(
      http.post, _authServerApi, 'signout', payload,
      headers: {});
  final data = parseResponseMap(response);
  return data.isEmpty;
}

/// Invalidates the accessToken of given [mojangAccount].
Future<bool> invalidate(MojangAccount mojangAccount) async {
  final payload = {
    'accessToken': mojangAccount.accessToken,
    'clientToken': mojangAccount.clientToken,
  };
  final response = await requestBody(
      http.post, _authServerApi, 'invalidate', payload,
      headers: {});
  final data = parseResponseMap(response);
  return data.isEmpty;
}

/// Changes the [currentPassword] to the new [newPassword]. This requires a valid
/// [accessToken] and will throw a [ArgumentError] if it is not.
/// Be careful to what values you pass into [newPassword], as the [accessToken] will
/// get invalidated and you will need it to log into your account again.
Future<bool> changePassword(
    String currentPassword, String newPassword, String accessToken) async {
  if (currentPassword.isEmpty) {
    throw ArgumentError.value(currentPassword, 'currentPassword',
        'The current password cannot be empty.');
  } else if (newPassword.isEmpty) {
    throw ArgumentError.value(
        newPassword, 'newPassword', 'The new password cannot be empty.');
  }

  final payload = {
    'authorization': accessToken,
    'content-type': 'application/json'
  };
  final response =
      await requestBody(http.put, _mojangApi, 'users/password', payload);
  switch (response.statusCode) {
    case 400:
      {
        final map = parseResponseMap(response);
        if (map['error'] == 'IllegalArgumentException') {
          throw ArgumentError.value(
              currentPassword, 'currentPassword', map['errorMessage']);
        }
        return false;
      }
    case 401:
      {
        final map = parseResponseMap(response);
        throw ArgumentError.value(
            accessToken, 'accessToken', map['errorMessage']);
      }
  }

  return response.statusCode == 204;
}

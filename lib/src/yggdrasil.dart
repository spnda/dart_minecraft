import 'mojang/mojang_account.dart';
import 'yggdrasil_api.dart' as api;

@deprecated
class Yggdrasil {
  /// Authenticates a user with given credentials [username] and [password].
  ///
  /// [clientToken] should be identical for each request, otherwise old
  /// access tokens will be invalidated. If omitted, a randomly generated
  /// version 4 UUID will be used.
  @deprecated
  static Future<MojangAccount> authenticate(String username, String password,
      {String? clientToken}) async {
    return api.authenticate(username, password);
  }

  /// Refreshes the [account]. The [account] data will be overridden with the new
  /// refreshed data. The return value is also the same [account] object.
  @deprecated
  static Future<MojangAccount> refresh(MojangAccount account) async {
    return api.refresh(account);
  }

  /// Checks if given [accessToken] and [clientToken] are still valid.
  ///
  /// [clientToken] is optional, though if provided should match the client token
  /// that was used to obtained given [accessToken].
  @deprecated
  static Future<bool> validate(String accessToken,
      {String? clientToken}) async {
    return api.validate(accessToken);
  }

  /// Signs the user out and invalidates the accessToken.
  @deprecated
  static Future<bool> signout(String username, String password) async {
    return api.signout(username, password);
  }

  /// Invalidates the accessToken of given [mojangAccount].
  @deprecated
  static Future<bool> invalidate(MojangAccount mojangAccount) async {
    return api.invalidate(mojangAccount);
  }
}

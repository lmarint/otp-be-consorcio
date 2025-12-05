
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_models.dart';

class SessionStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'auth_token';
  static const _keyRequestId = 'request_id';
  static const _keyExpireMinutes = 'token_expire_minutes';

  static Future<void> saveToken(TokenDto t) async {
    await _storage.write(key: _keyToken, value: t.token);
    await _storage.write(key: _keyRequestId, value: t.requestId);
    await _storage.write(key: _keyExpireMinutes, value: t.expiracion.toString());
  }

  static Future<String?> getToken() => _storage.read(key: _keyToken);
  static Future<String?> getRequestId() => _storage.read(key: _keyRequestId);

  static Future<int?> getExpireMinutes() async {
    final s = await _storage.read(key: _keyExpireMinutes);
    return s == null ? null : int.tryParse(s);
  }

  static Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRequestId);
    await _storage.delete(key: _keyExpireMinutes);
  }
}

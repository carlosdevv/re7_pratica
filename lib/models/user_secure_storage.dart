import 'package:get_storage/get_storage.dart';

class UserSecureStorage {
  static final _storage = GetStorage();

  static const _keyToken = 'token';
  static const _keyCode = 'id_cliente';
  static const _keyUser = 'usuario';

  static setToken(String token) => _storage.write(_keyToken, token);
  static setCode(String code) => _storage.write(_keyCode, code);
  static setUser(String user) => _storage.write(_keyUser, user);

  static String? getToken() => _storage.read(_keyToken);
  static String? getCode() => _storage.read(_keyCode);
  static String? getUser() => _storage.read(_keyUser);

  static void removeStorage() {
    _storage.remove(_keyToken);
    _storage.remove(_keyCode);
    _storage.remove(_keyUser);
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreSession {
  static const _storage = FlutterSecureStorage();

  static const _token = 'token';
  static const _coinleeUserId = 'coinleeUserId';
  static const _firstName = 'firstName';
  static const _lastName = 'lastName';
  static const _userMobile = 'userMobile';
  static const _userPassword = 'userPassword';
  static const _userEmail = 'userEmail';
  static const _userReferalCode = 'user_referal_code';

  static Future setToken(String token) async =>
      await _storage.write(key: _token, value: token);

  static Future setcoinleeUserId(String coinleeUserId) async =>
      await _storage.write(key: _coinleeUserId, value: coinleeUserId);

  static Future setFirstName(String firstName) async =>
      await _storage.write(key: _firstName, value: firstName);

  static Future setlastName(String lastName) async =>
      await _storage.write(key: _lastName, value: lastName);

  static Future setuserMobile(String userMobile) async =>
      await _storage.write(key: _userMobile, value: userMobile);

  static Future setuserPassword(String userPassword) async =>
      await _storage.write(key: _userPassword, value: userPassword);

  static Future setuserEmail(String userEmail) async =>
      await _storage.write(key: _userEmail, value: userEmail);

  static Future setReferralCode(String userReferalCode) async =>
      await _storage.write(key: _userReferalCode, value: userReferalCode);

  static Future getToken() async => await _storage.read(key: _token);
  static Future getCoinleeUserId() async =>
      await _storage.read(key: _coinleeUserId);
  static Future getFirstName() async => await _storage.read(key: _firstName);
  static Future getLastname() async => await _storage.read(key: _lastName);
  static Future getUserMobile() async => await _storage.read(key: _userMobile);
  static Future getUserPassword() async =>
      await _storage.read(key: _userPassword);
  static Future getEmail() async => await _storage.read(key: _userEmail);
  static Future getReferralCode() async =>
      await _storage.read(key: _userReferalCode);

  static Future clearSession() async => await _storage.deleteAll();
}

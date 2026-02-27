import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes_vault/core/enums/app_enums.dart';

class SecureStorage{

  static const _secureStorage = FlutterSecureStorage();

  static AppKeys _getAppKey(AppKeys key){
    switch(key){
      case AppKeys.appPin:
        return AppKeys.appPin;
      case AppKeys.accessToken:
        return AppKeys.accessToken;
      case AppKeys.refreshToken:
        return AppKeys.refreshToken;
    }
  }

  static Future<void> write(AppKeys key, String value) async {
    await _secureStorage.write(key: _getAppKey(key).toString(), value: value);
  }

  static Future<String?> read(AppKeys key) async {
    return await _secureStorage.read(key: _getAppKey(key).toString());
  }

  static Future<void> delete(AppKeys key) async{
    await _secureStorage.delete(key: _getAppKey(key).toString());
  }

}
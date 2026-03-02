import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/security/secure_storage.dart';

/// AES-256-CBC encryption with a randomly generated key stored in
/// [FlutterSecureStorage]. Each call to [encrypt] produces a unique
/// ciphertext because a fresh random IV is generated every time.
///
/// The key does NOT depend on the user's PIN — it is recoverable via
/// server backup (to be added with sync feature).
class EncryptionService {
  static Encrypter? _encrypter;
  static Key? _key;

  /// Returns the [Encrypter] instance, lazily creating (or loading) the
  /// AES-256 key on first access.
  static Future<Encrypter> _getEncrypter() async {
    if (_encrypter != null) return _encrypter!;

    final storedKey = await SecureStorage.read(AppKeys.encryptionKey);

    if (storedKey != null) {
      _key = Key.fromBase64(storedKey);
    } else {
      // Generate a new 256-bit key and persist it.
      _key = Key.fromSecureRandom(32);
      await SecureStorage.write(AppKeys.encryptionKey, _key!.base64);
    }

    _encrypter = Encrypter(AES(_key!, mode: AESMode.cbc));
    return _encrypter!;
  }

  /// Encrypts [plaintext] with AES-256-CBC using a random IV.
  /// Returns a base64 string of `IV (16 bytes) + ciphertext`.
  static Future<String> encrypt(String plaintext) async {
    final encrypter = await _getEncrypter();
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    // Prepend IV bytes so we can extract it during decryption.
    final combined = iv.bytes + encrypted.bytes;
    return base64.encode(combined);
  }

  /// Decrypts a base64-encoded string produced by [encrypt].
  /// Extracts the 16-byte IV prefix and then decrypts the remainder.
  static Future<String> decrypt(String encoded) async {
    final encrypter = await _getEncrypter();
    final combined = base64.decode(encoded);

    final iv = IV(combined.sublist(0, 16));
    final cipherBytes = combined.sublist(16);
    final encrypted = Encrypted(cipherBytes);

    return encrypter.decrypt(encrypted, iv: iv);
  }
}

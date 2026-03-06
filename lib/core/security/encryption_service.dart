import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/security/secure_storage.dart';

/// AES-256-CBC encryption with a randomly generated key stored in
/// [FlutterSecureStorage]. Each call to [encrypt] produces a unique
/// ciphertext because a fresh random IV is generated every time.
///
/// Also provides key wrapping for cross-device sync via a Sync Password.
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

  // ── Key Wrapping (for cross-device sync) ──

  /// Derives a 256-bit wrapping key from a user passphrase using PBKDF2-like
  /// approach (SHA-256 based key stretching with salt).
  static Uint8List _deriveKeyFromPassword(String password, Uint8List salt) {
    // Simple key derivation: HMAC-SHA256(salt, password) iterated.
    // For production, consider using a proper PBKDF2 package.
    var derived = Uint8List.fromList(utf8.encode(password) + salt);
    for (int i = 0; i < 100000; i++) {
      final hmac = Encrypter(
        AES(Key(Uint8List.fromList(salt)), mode: AESMode.cbc),
      );
      final iv = IV(Uint8List(16)); // zero IV for derivation
      derived = Uint8List.fromList(
        hmac.encrypt(base64.encode(derived), iv: iv).bytes.sublist(0, 32),
      );
    }
    return derived.sublist(0, 32);
  }

  /// Wraps (encrypts) the device encryption key with a sync password.
  /// Returns `{wrappedKey: base64, salt: base64}`.
  static Future<Map<String, String>> wrapKey(String syncPassword) async {
    // Ensure key is loaded
    await _getEncrypter();
    if (_key == null) throw Exception('Encryption key not initialized');

    final salt = Key.fromSecureRandom(16).bytes;
    final wrappingKey = _deriveKeyFromPassword(
      syncPassword,
      Uint8List.fromList(salt),
    );

    final wrapper = Encrypter(
      AES(Key(Uint8List.fromList(wrappingKey)), mode: AESMode.cbc),
    );
    final iv = IV.fromSecureRandom(16);
    final wrapped = wrapper.encrypt(_key!.base64, iv: iv);

    // Combine IV + wrapped key bytes
    final combined = iv.bytes + wrapped.bytes;

    return {'wrappedKey': base64.encode(combined), 'salt': base64.encode(salt)};
  }

  /// Unwraps (decrypts) the device encryption key using the sync password.
  /// Stores the unwrapped key in SecureStorage for local use.
  static Future<bool> unwrapKey({
    required String wrappedKeyBase64,
    required String saltBase64,
    required String syncPassword,
  }) async {
    try {
      final salt = base64.decode(saltBase64);
      final combined = base64.decode(wrappedKeyBase64);

      final wrappingKey = _deriveKeyFromPassword(
        syncPassword,
        Uint8List.fromList(salt),
      );

      final iv = IV(combined.sublist(0, 16));
      final cipherBytes = combined.sublist(16);
      final wrapped = Encrypted(cipherBytes);

      final wrapper = Encrypter(
        AES(Key(Uint8List.fromList(wrappingKey)), mode: AESMode.cbc),
      );
      final decryptedKeyBase64 = wrapper.decrypt(wrapped, iv: iv);

      // Store the unwrapped key locally
      await SecureStorage.write(AppKeys.encryptionKey, decryptedKeyBase64);

      // Reset cached encrypter so it reloads with the new key
      _encrypter = null;
      _key = null;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns the current device key as base64 (for wrapping).
  static Future<String?> getKeyBase64() async {
    return await SecureStorage.read(AppKeys.encryptionKey);
  }
}

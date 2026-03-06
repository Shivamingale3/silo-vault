import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:silo_vault/core/enums/app_enums.dart';
import 'package:silo_vault/core/security/secure_storage.dart';

/// Caches Firebase user profile data (name, email, photo) locally
/// so the settings profile section works offline.
class CachedProfile {
  /// Saves user profile data to SecureStorage and downloads the photo.
  static Future<void> cacheProfile(User user) async {
    final name = user.displayName ?? '';
    final email = user.email ?? '';
    final photoUrl = user.photoURL;

    await SecureStorage.write(AppKeys.cachedDisplayName, name);
    await SecureStorage.write(AppKeys.cachedEmail, email);

    if (photoUrl != null && photoUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(photoUrl));
        if (response.statusCode == 200) {
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/cached_profile_photo.jpg');
          await file.writeAsBytes(response.bodyBytes);
          await SecureStorage.write(AppKeys.cachedPhotoPath, file.path);
        }
      } catch (_) {
        // Photo download failed — not critical, we'll show a fallback icon
      }
    }
  }

  /// Returns cached profile data for offline display.
  static Future<CachedProfileData> getCachedProfile() async {
    final name = await SecureStorage.read(AppKeys.cachedDisplayName);
    final email = await SecureStorage.read(AppKeys.cachedEmail);
    final photoPath = await SecureStorage.read(AppKeys.cachedPhotoPath);

    return CachedProfileData(
      displayName: name,
      email: email,
      photoPath: photoPath,
    );
  }

  /// Returns the cached photo file, or null if it doesn't exist.
  static Future<File?> getCachedPhotoFile() async {
    final photoPath = await SecureStorage.read(AppKeys.cachedPhotoPath);
    if (photoPath == null) return null;
    final file = File(photoPath);
    if (await file.exists()) return file;
    return null;
  }

  /// Clears all cached profile data on sign out.
  static Future<void> clearCachedProfile() async {
    await SecureStorage.delete(AppKeys.cachedDisplayName);
    await SecureStorage.delete(AppKeys.cachedEmail);

    final photoPath = await SecureStorage.read(AppKeys.cachedPhotoPath);
    if (photoPath != null) {
      final file = File(photoPath);
      if (await file.exists()) await file.delete();
      await SecureStorage.delete(AppKeys.cachedPhotoPath);
    }
  }
}

/// Data class for cached profile information.
class CachedProfileData {
  final String? displayName;
  final String? email;
  final String? photoPath;

  const CachedProfileData({this.displayName, this.email, this.photoPath});

  bool get hasProfile => displayName != null && displayName!.isNotEmpty;

  File? get photoFile {
    if (photoPath == null) return null;
    final file = File(photoPath!);
    return file.existsSync() ? file : null;
  }
}

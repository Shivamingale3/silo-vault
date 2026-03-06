import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_vault/core/services/cached_profile.dart';

/// Handles Firebase Authentication via Google Sign-In.
/// Caches profile data locally for offline display.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Sign In ──

  /// Signs in with Google and caches profile data locally.
  /// Returns the [User] on success, `null` on failure/cancellation.
  static Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user cancelled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await CachedProfile.cacheProfile(user);
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  // ── Sign Out ──

  /// Signs out from both Firebase and Google, clears cached profile.
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await CachedProfile.clearCachedProfile();
  }

  // ── Token Management ──

  /// Force-refreshes the Firebase ID token.
  /// Returns `true` if token is valid, `false` if refresh failed (offline/revoked).
  /// Call this before any Firestore operation.
  static Future<bool> refreshTokenIfNeeded() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      await user.getIdToken(true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Getters ──

  static User? get currentUser => _auth.currentUser;

  static bool get isAuthenticated => _auth.currentUser != null;

  static String? get uid => _auth.currentUser?.uid;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}

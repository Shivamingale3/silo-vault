import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/services/auth_service.dart';

/// Watches Firebase auth state changes (sign in / sign out).
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

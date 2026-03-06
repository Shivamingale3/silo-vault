import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silo_vault/core/services/connectivity_service.dart';

/// Exposes real-time connectivity status.
final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.onlineStream;
});

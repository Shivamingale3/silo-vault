import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks network connectivity before sync operations.
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Returns `true` if the device has an active internet connection.
  static Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Stream that emits `true`/`false` as connectivity changes.
  static Stream<bool> get onlineStream {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.any((r) => r != ConnectivityResult.none),
    );
  }
}

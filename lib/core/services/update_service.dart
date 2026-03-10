import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  final String version;
  final String changelog;
  final String downloadUrl;
  final String tagName;

  UpdateInfo({
    required this.version,
    required this.changelog,
    required this.downloadUrl,
    required this.tagName,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    final assets = json['assets'] as List;
    final apkAsset = assets.firstWhere(
      (asset) => asset['name'].toString().endsWith('.apk'),
      orElse: () => assets.isNotEmpty ? assets.first : null,
    );

    return UpdateInfo(
      version: json['name'] ?? json['tag_name'],
      tagName: json['tag_name'],
      changelog: json['body'] ?? 'No changelog provided.',
      downloadUrl: apkAsset != null ? apkAsset['browser_download_url'] : '',
    );
  }
}

class GitHubUpdateService {
  static const String _repoOwner = 'Shivamingale3';
  static const String _repoName = 'silo-vault';
  static const String _apiUrl = 'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest';

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestUpdate = UpdateInfo.fromJson(data);
        
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        if (_isNewerVersion(latestUpdate.tagName, currentVersion)) {
          return latestUpdate;
        }
      }
    } catch (e) {
      print('Error checking for update: $e');
    }
    return null;
  }

  bool _isNewerVersion(String latest, String current) {
    List<int> latestParts = latest.replaceAll(RegExp(r'[^0-9.]'), '').split('.').map(int.parse).toList();
    List<int> currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  Future<String?> downloadUpdate(String url, Function(double) onProgress) async {
    try {
      final dio = Dio();
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/app-update.apk';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      return filePath;
    } catch (e) {
      print('Error downloading update: $e');
      return null;
    }
  }
}

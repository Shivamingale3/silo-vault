import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:silo_vault/core/enums/app_enums.dart';
import 'package:silo_vault/core/security/secure_storage.dart';
import 'package:silo_vault/core/services/update_service.dart';

enum UpdateStatus { idle, checking, available, downloading, ready, error }

class UpdateState {
  final UpdateStatus status;
  final UpdateInfo? updateInfo;
  final double progress;
  final String? error;
  final String? localPath;

  UpdateState({
    required this.status,
    this.updateInfo,
    this.progress = 0,
    this.error,
    this.localPath,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    UpdateInfo? updateInfo,
    double? progress,
    String? error,
    String? localPath,
  }) {
    return UpdateState(
      status: status ?? this.status,
      updateInfo: updateInfo ?? this.updateInfo,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      localPath: localPath ?? this.localPath,
    );
  }
}

class UpdateNotifier extends Notifier<UpdateState> {
  final GitHubUpdateService _service = GitHubUpdateService();

  @override
  UpdateState build() {
    return UpdateState(status: UpdateStatus.idle);
  }

  Future<void> checkForUpdate() async {
    state = state.copyWith(status: UpdateStatus.checking);
    final update = await _service.checkForUpdate();

    if (update != null) {
      await SecureStorage.write(AppKeys.updateAvailable, 'true');
      await SecureStorage.write(AppKeys.updateVersion, update.tagName);
      state = state.copyWith(
        status: UpdateStatus.available,
        updateInfo: update,
      );
    } else {
      await SecureStorage.write(AppKeys.updateAvailable, 'false');
      state = state.copyWith(status: UpdateStatus.idle);
    }
  }

  Future<void> downloadAndInstall() async {
    if (state.status == UpdateStatus.error) {
      state = state.copyWith(status: UpdateStatus.idle);
      await checkForUpdate();
      return;
    }
    
    if (state.status == UpdateStatus.ready) {
      await installUpdate();
      return;
    }

    if (state.updateInfo == null || state.status == UpdateStatus.downloading) {
      return;
    }

    state = state.copyWith(status: UpdateStatus.downloading, progress: 0);

    final path = await _service.downloadUpdate(state.updateInfo!.downloadUrl, (
      progress,
    ) {
      state = state.copyWith(progress: progress);
    });

    if (path != null) {
      state = state.copyWith(status: UpdateStatus.ready, localPath: path);
      // Automatically attempt installation after download
      await installUpdate();
    } else {
      state = state.copyWith(
        status: UpdateStatus.error,
        error: 'Download failed',
      );
    }
  }

  Future<void> installUpdate() async {
    if (state.localPath != null) {
      final file = File(state.localPath!);
      if (!await file.exists()) {
        print('Error: Downloaded file does not exist at ${state.localPath}');
        state = state.copyWith(
          status: UpdateStatus.error,
          error: 'Downloaded file not found',
        );
        return;
      }

      final fileSize = await file.length();
      print('File size: $fileSize bytes');

      final result = await OpenFilex.open(
        state.localPath!,
        type: 'application/vnd.android.package-archive',
      );
      print('Installation result: ${result.type} - ${result.message}');
      if (result.type != ResultType.done) {
        state = state.copyWith(
          status: UpdateStatus.error,
          error: 'Installation failed: ${result.message}',
        );
      }
    }
  }

  Future<void> init() async {
    final isUpdateAvailable = await SecureStorage.read(AppKeys.updateAvailable);
    if (isUpdateAvailable == 'true') {
      checkForUpdate();
    }
  }
}

final updateProvider = NotifierProvider<UpdateNotifier, UpdateState>(() {
  return UpdateNotifier();
});

import 'package:flutter/material.dart';

/// Modal dialog showing sync progress with animated status updates.
/// Cannot be dismissed during sync.
class SyncProgressDialog extends StatelessWidget {
  final String statusText;
  final bool isDone;
  final bool isError;
  final VoidCallback? onDone;

  const SyncProgressDialog({
    super.key,
    required this.statusText,
    this.isDone = false,
    this.isError = false,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: isDone || isError,
      child: Dialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon / Indicator
              if (isDone)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 32,
                  ),
                )
              else if (isError)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                )
              else
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: theme.colorScheme.primary,
                  ),
                ),

              const SizedBox(height: 20),

              // Title
              Text(
                isDone
                    ? 'Sync Complete'
                    : isError
                    ? 'Sync Failed'
                    : 'Syncing...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              // Status text
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),

              if (isDone || isError) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onDone ?? () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDone
                          ? theme.colorScheme.primary
                          : Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isDone ? 'Done' : 'Close',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper to show the sync progress dialog as a managed flow.
Future<void> showSyncProgressFlow(
  BuildContext context, {
  required Future<({bool success, String message})> Function() syncOperation,
  VoidCallback? onComplete,
}) async {
  String status = 'Preparing sync...';
  bool done = false;
  bool error = false;
  StateSetter? dialogSetState;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        dialogSetState = setState;
        return SyncProgressDialog(
          statusText: status,
          isDone: done,
          isError: error,
          onDone: () {
            Navigator.pop(ctx);
            if (done && onComplete != null) onComplete();
          },
        );
      },
    ),
  );

  // Give dialog time to appear
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    dialogSetState?.call(() => status = 'Syncing your data...');

    final result = await syncOperation();

    dialogSetState?.call(() {
      status = result.message;
      done = result.success;
      error = !result.success;
    });
  } catch (e) {
    dialogSetState?.call(() {
      status = 'Unexpected error: $e';
      error = true;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/providers/dev_mode_provider.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import 'package:notes_vault/core/security/secure_storage.dart';
import 'package:notes_vault/core/services/auth_service.dart';
import 'package:notes_vault/core/services/cached_profile.dart';
import 'package:notes_vault/core/services/connectivity_service.dart';
import 'package:notes_vault/core/services/data_transfer_service.dart';
import 'package:notes_vault/core/services/sync_service.dart';
import 'package:notes_vault/core/theme/theme_provider.dart';
import 'package:notes_vault/database/firestore_repository.dart';
import 'package:notes_vault/features/widgets/sync/sync_password_entry_sheet.dart';
import 'package:notes_vault/features/widgets/sync/sync_password_setup_sheet.dart';
import 'package:notes_vault/features/widgets/sync/sync_progress_dialog.dart';
import 'package:notes_vault/security/biometric_auth.dart';
import 'package:notes_vault/core/enums/security_enums.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricUnlock = false;
  bool _syncToCloud = false;
  int _versionClickCount = 0;
  int _autoLockSeconds = 60;
  int _maxAttempts = 5;
  CachedProfileData? _cachedProfile;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final bio = await SecureStorage.getBiometricStatus();
    final lock = await SecureStorage.getAutoLockTimeout();
    final attempts = await SecureStorage.getMaxUnlockAttempts();
    final syncEnabled = await SyncService.isSyncEnabled();
    final profile = await CachedProfile.getCachedProfile();
    if (!mounted) return;
    setState(() {
      _biometricUnlock = bio;
      _autoLockSeconds = lock;
      _maxAttempts = attempts;
      _syncToCloud = syncEnabled;
      _cachedProfile = profile;
    });
  }

  Future<void> _handleSignIn() async {
    final user = await AuthService.signInWithGoogle();
    if (user == null || !mounted) return;
    final profile = await CachedProfile.getCachedProfile();
    if (!mounted) return;
    setState(() => _cachedProfile = profile);
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Your local data will remain. Cloud sync will stop.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await SyncService.disableSync();
    await AuthService.signOut();
    if (!mounted) return;
    setState(() {
      _syncToCloud = false;
      _cachedProfile = null;
    });
  }

  Future<void> _handleSyncToggle(bool val) async {
    if (val) {
      // Enabling sync
      if (!await ConnectivityService.isOnline()) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No internet connection')));
        return;
      }

      // Must be signed in first
      if (!AuthService.isAuthenticated) {
        await _handleSignIn();
        if (!AuthService.isAuthenticated || !mounted) return;
      }

      // Check if this account already has a wrapped key (existing sync)
      final hasKey = await FirestoreRepository.hasWrappedKey();

      if (hasKey) {
        // Existing sync — ask for sync password
        if (!mounted) return;
        final result = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => SyncPasswordEntrySheet(
            onPasswordEntered: (password) async {
              final r = await SyncService.setupFromRemote(password);
              return r.success;
            },
          ),
        );
        if (result == true && mounted) {
          ref.invalidate(vaultProvider);
          setState(() => _syncToCloud = true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sync setup complete!')));
        }
      } else {
        // New sync — set up sync password
        if (!mounted) return;
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => SyncPasswordSetupSheet(
            onPasswordSet: (password) async {
              final result = await SyncService.initializeSync(password);
              if (!result.success) throw Exception(result.message);
            },
          ),
        );
        // Check if sync was actually enabled
        final enabled = await SyncService.isSyncEnabled();
        if (mounted) {
          setState(() => _syncToCloud = enabled);
          if (enabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cloud sync enabled!')),
            );
          }
        }
      }
    } else {
      // Disabling sync
      await SyncService.disableSync();
      if (mounted) setState(() => _syncToCloud = false);
    }
  }

  Future<void> _handleSyncNow() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    await showSyncProgressFlow(
      context,
      syncOperation: () async {
        final r = await SyncService.fullSync();
        return (success: r.success, message: r.message);
      },
      onComplete: () {
        ref.invalidate(vaultProvider);
      },
    );

    if (mounted) setState(() => _isSyncing = false);
  }

  String _autoLockLabel(int seconds) {
    if (seconds == 0) return 'Immediately';
    if (seconds < 60) return '$seconds seconds';
    if (seconds == 60) return '1 minute';
    if (seconds == 300) return '5 minutes';
    if (seconds == 600) return '10 minutes';
    if (seconds == 1800) return '30 minutes';
    return '${seconds ~/ 60} minutes';
  }

  void _showAutoLockPicker() {
    final options = [0, 30, 60, 300, 600, 1800];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Auto Lock After',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...options.map(
              (s) => ListTile(
                title: Text(_autoLockLabel(s)),
                trailing: s == _autoLockSeconds
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  await SecureStorage.setAutoLockTimeout(s);
                  setState(() => _autoLockSeconds = s);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showMaxAttemptsPicker() {
    final options = [3, 5, 7, 10];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Max Failed Attempts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...options.map(
              (a) => ListTile(
                title: Text('$a attempts'),
                trailing: a == _maxAttempts
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  await SecureStorage.setMaxUnlockAttempts(a);
                  setState(() => _maxAttempts = a);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final devModeEnabled = ref.watch(devModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 24,
                  bottom: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileSection(primaryColor),
                    SizedBox(height: 24),
                    _buildAppearanceSection(primaryColor),
                    SizedBox(height: 24),
                    _buildSecuritySection(primaryColor),
                    SizedBox(height: 24),
                    _buildDataAndAboutSection(primaryColor, devModeEnabled),
                    if (devModeEnabled) ...[
                      SizedBox(height: 24),
                      _buildDeveloperSection(primaryColor),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(Color primaryColor) {
    final theme = Theme.of(context);
    final isSignedIn =
        AuthService.isAuthenticated && _cachedProfile?.hasProfile == true;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: isSignedIn
          ? _buildSignedInProfile(theme, primaryColor)
          : _buildGuestProfile(theme, primaryColor),
    );
  }

  Widget _buildSignedInProfile(ThemeData theme, Color primaryColor) {
    final profile = _cachedProfile!;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: primaryColor.withValues(alpha: 0.2),
          backgroundImage: profile.photoFile != null
              ? FileImage(profile.photoFile!)
              : null,
          child: profile.photoFile == null
              ? Icon(Icons.person, color: primaryColor, size: 28)
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.displayName ?? 'User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (profile.email != null) ...[
                const SizedBox(height: 2),
                Text(
                  profile.email!,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.54),
                  ),
                ),
              ],
              const SizedBox(height: 2),
              Consumer(
                builder: (context, ref, _) {
                  final stats = ref.watch(vaultStatsProvider);
                  return Text(
                    '${stats.passwordCount} passwords \u00B7 ${stats.noteCount} notes',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _handleSignOut,
          icon: Icon(
            Icons.logout_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            size: 20,
          ),
          tooltip: 'Sign Out',
        ),
      ],
    );
  }

  Widget _buildGuestProfile(ThemeData theme, Color primaryColor) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Icon(
                  Icons.account_circle,
                  color: primaryColor,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Vault',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Consumer(
                    builder: (context, ref, _) {
                      final stats = ref.watch(vaultStatsProvider);
                      return Text(
                        '${stats.passwordCount} passwords \u00B7 ${stats.noteCount} notes',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.54,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: _handleSignIn,
            icon: Icon(Icons.login_rounded, size: 18),
            label: const Text(
              'Sign in to enable sync',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'APPEARANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildAppearanceButton('Light', AppThemeMode.light, primaryColor),
              _buildAppearanceButton('Dark', AppThemeMode.dark, primaryColor),
              _buildAppearanceButton(
                'AMOLED',
                AppThemeMode.amoled,
                primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceButton(
    String label,
    AppThemeMode mode,
    Color primaryColor,
  ) {
    final activeMode = ref.watch(themeProvider);
    final isActive = activeMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(themeProvider.notifier).setTheme(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.54),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'SECURITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _buildSettingsActionItem(
                  'Change PIN',
                  onTap: () => context.push(AppRoutes.pinSetup),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsToggleItem('Biometric Unlock', _biometricUnlock, (
                  val,
                ) async {
                  final result = await BiometricAuth.authenticate();
                  if (result == BiometricResult.success) {
                    await SecureStorage.setBiometricStatus(val);
                    setState(() => _biometricUnlock = val);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Authentication required to change this setting',
                          ),
                        ),
                      );
                    }
                  }
                }, primaryColor),
                _buildDivider(),
                _buildSettingsLabelItem(
                  'Auto Lock',
                  _autoLockLabel(_autoLockSeconds),
                  onTap: _showAutoLockPicker,
                ),
                _buildDivider(),
                _buildSettingsLabelItem(
                  'Max Attempts',
                  '$_maxAttempts',
                  isLast: true,
                  onTap: _showMaxAttemptsPicker,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataAndAboutSection(Color primaryColor, bool devModeEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'DATA & ABOUT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _buildSettingsToggleItem(
                  'Sync to Cloud',
                  _syncToCloud,
                  _handleSyncToggle,
                  primaryColor,
                ),
                if (_syncToCloud) ...[
                  _buildDivider(),
                  _buildSettingsActionItem(
                    'Sync Now',
                    onTap: _handleSyncNow,
                    trailing: _isSyncing
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.sync_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                            size: 20,
                          ),
                  ),
                ],
                _buildDivider(),
                _buildSettingsActionItem(
                  'Import Data',
                  onTap: () async {
                    final service = DataTransferService();
                    final count = await service.importFromJson();
                    if (!mounted) return;
                    if (count > 0) {
                      ref.invalidate(vaultProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Imported $count items'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else if (count == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No items to import'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Import failed — invalid file'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  trailing: Icon(
                    Icons.download,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsActionItem(
                  'Export Data',
                  onTap: () async {
                    final service = DataTransferService();
                    final path = await service.exportToJson();
                    if (!mounted) return;
                    if (path != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Exported to $path'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nothing to export'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  trailing: Icon(
                    Icons.upload,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsLabelItem(
                  'Backup Reminder',
                  'Monthly',
                  valueColor: primaryColor,
                ),
                _buildDivider(),
                _buildSettingsLabelItem(
                  'Version',
                  '1.2.0',
                  isMonospace: true,
                  isLast: true,
                  onTap: () {
                    if (devModeEnabled) return;
                    _versionClickCount++;
                    if (_versionClickCount >= 8) {
                      ref.read(devModeProvider.notifier).toggleDevMode(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Developer Mode Enabled'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (_versionClickCount >= 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You are ${8 - _versionClickCount} steps away from being a developer.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsActionItem(
    String label, {
    required Widget trailing,
    VoidCallback? onTap,
    Color? labelColor,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: labelColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsToggleItem(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    Color activeColor,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Theme.of(context).colorScheme.onSurface,
              activeTrackColor: activeColor,
              inactiveThumbColor: Theme.of(context).colorScheme.onSurface,
              inactiveTrackColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsLabelItem(
    String label,
    String value, {
    Color? valueColor,
    bool isMonospace = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    Widget content = Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: isLast ? 14 : 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: isMonospace ? 'monospace' : null,
              fontWeight: isMonospace ? FontWeight.bold : FontWeight.w500,
              color:
                  valueColor ??
                  Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.54),
              letterSpacing: isMonospace ? -0.5 : 0,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: content);
    }
    return content;
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDeveloperSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'DEVELOPER OPTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.54),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _buildSettingsActionItem(
                  'View Database',
                  onTap: () => context.push(AppRoutes.dbViewer),
                  trailing: Icon(
                    Icons.data_object,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsActionItem(
                  'View Logs',
                  trailing: Icon(
                    Icons.developer_board,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsActionItem(
                  'Disable Developer Mode',
                  onTap: () {
                    ref.read(devModeProvider.notifier).toggleDevMode(false);
                    setState(() {
                      _versionClickCount = 0;
                    });
                  },
                  trailing: Icon(
                    Icons.close,
                    color: Colors.red.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  labelColor: Colors.red.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

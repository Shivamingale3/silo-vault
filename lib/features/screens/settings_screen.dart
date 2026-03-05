import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/providers/dev_mode_provider.dart';
import 'package:notes_vault/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricUnlock = true;
  bool _syncToCloud = false;
  int _versionClickCount = 0;

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
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
              child: Icon(Icons.account_circle, color: primaryColor, size: 32),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Local Vault',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.54),
                ),
              ),
            ],
          ),
        ],
      ),
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
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildSettingsToggleItem(
                  'Biometric Unlock',
                  _biometricUnlock,
                  (val) => setState(() => _biometricUnlock = val),
                  primaryColor,
                ),
                _buildDivider(),
                _buildSettingsLabelItem('Auto Lock', '1 minute'),
                _buildDivider(),
                _buildSettingsLabelItem('Max Attempts', '5', isLast: true),
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
                  (val) => setState(() => _syncToCloud = val),
                  primaryColor,
                ),
                _buildDivider(),
                _buildSettingsActionItem(
                  'Import Data',
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

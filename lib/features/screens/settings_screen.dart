import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_vault/core/enums/app_enums.dart';
import 'package:notes_vault/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricUnlock = true;
  bool _syncToCloud = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1152d4);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
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
                    const SizedBox(height: 24),
                    _buildAppearanceSection(primaryColor),
                    const SizedBox(height: 24),
                    _buildSecuritySection(primaryColor),
                    const SizedBox(height: 24),
                    _buildDataAndAboutSection(primaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: IconButton(
              icon: const Icon(Icons.lock, color: Colors.white, size: 20),
              onPressed: () {},
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Local Vault',
                style: TextStyle(fontSize: 12, color: Colors.white54),
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
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'APPEARANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white54,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
              color: isActive ? Colors.white : Colors.white54,
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
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'SECURITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white54,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildSettingsActionItem(
                'Change PIN',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white30,
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
      ],
    );
  }

  Widget _buildDataAndAboutSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'DATA & ABOUT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white54,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
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
                trailing: const Icon(
                  Icons.download,
                  color: Colors.white30,
                  size: 20,
                ),
              ),
              _buildDivider(),
              _buildSettingsActionItem(
                'Export Data',
                trailing: const Icon(
                  Icons.upload,
                  color: Colors.white30,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsActionItem(String label, {required Widget trailing}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: activeColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white12,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsLabelItem(
    String label,
    String value, {
    Color? valueColor,
    bool isMonospace = false,
    bool isLast = false,
  }) {
    return Padding(
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
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: isMonospace ? 'monospace' : null,
              fontWeight: isMonospace ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? Colors.white54,
              letterSpacing: isMonospace ? -0.5 : 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

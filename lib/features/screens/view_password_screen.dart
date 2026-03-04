import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/constants/app_routes.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/features/models/vault_item.dart';

class ViewPasswordScreen extends StatefulWidget {
  final VaultItem item;

  const ViewPasswordScreen({super.key, required this.item});

  @override
  State<ViewPasswordScreen> createState() => _ViewPasswordScreenState();
}

class _ViewPasswordScreenState extends State<ViewPasswordScreen> {
  bool _passwordVisible = false;

  VaultItem get item => widget.item;

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _strengthColor(PasswordStrength? strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.blue;
      case PasswordStrength.veryStrong:
        return Colors.green;
      case null:
        return Colors.grey;
    }
  }

  String _strengthLabel(PasswordStrength? strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Password is weak — consider updating';
      case PasswordStrength.fair:
        return 'Password is fair — could be stronger';
      case PasswordStrength.strong:
        return 'Password is strong & unique';
      case PasswordStrength.veryStrong:
        return 'Password is very strong & unique';
      case null:
        return 'Password strength unknown';
    }
  }

  IconData _strengthIcon(PasswordStrength? strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Icons.warning_amber;
      case PasswordStrength.fair:
        return Icons.info_outline;
      case PasswordStrength.strong:
      case PasswordStrength.veryStrong:
        return Icons.check_circle;
      case null:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 20,
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 24),
            onPressed: () {
              context.push(AppRoutes.editPassword, extra: item);
            },
            splashRadius: 20,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 48,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              if (item.websiteUrl != null)
                Text(
                  Uri.tryParse(item.websiteUrl!)?.host ?? item.websiteUrl!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              const SizedBox(height: 40),

              if (item.username != null) ...[
                _buildInfoCard(
                  context,
                  label: 'USERNAME',
                  value: item.username!,
                  trailing: [
                    _buildActionButton(
                      context,
                      Icons.content_copy,
                      true,
                      onTap: () => _copyToClipboard(item.username!, 'Username'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (item.password != null) ...[
                _buildInfoCard(
                  context,
                  label: 'PASSWORD',
                  value: _passwordVisible ? item.password! : '••••••••••••',
                  isPassword: !_passwordVisible,
                  trailing: [
                    _buildActionButton(
                      context,
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      false,
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      Icons.content_copy,
                      true,
                      onTap: () => _copyToClipboard(item.password!, 'Password'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (item.websiteUrl != null) ...[
                _buildInfoCard(
                  context,
                  label: 'WEBSITE URL',
                  value: item.websiteUrl!,
                  isLink: true,
                  trailing: [
                    _buildActionButton(
                      context,
                      Icons.content_copy,
                      true,
                      onTap: () => _copyToClipboard(item.websiteUrl!, 'URL'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              _buildSecurityInsightCard(context),

              // Tags
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) {
                      final label =
                          tag.name[0].toUpperCase() + tag.name.substring(1);
                      return _buildTagChip(context, label);
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 48),
              Text(
                'Created: ${_formatDate(item.createdAt)} • Updated: ${item.timeAgoUpdated}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildTagChip(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String label,
    required String value,
    List<Widget>? trailing,
    bool isPassword = false,
    bool isLink = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.black54,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                if (isLink)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: isPassword ? 4.0 : 0.0,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (trailing != null)
            Row(mainAxisSize: MainAxisSize.min, children: trailing),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    bool isPrimary, {
    required VoidCallback onTap,
  }) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : (isDark ? Colors.white12 : Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary
              ? theme.colorScheme.primary
              : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSecurityInsightCard(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _strengthColor(item.passwordStrength);
    final label = _strengthLabel(item.passwordStrength);
    final icon = _strengthIcon(item.passwordStrength);

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECURITY INSIGHTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.black54,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

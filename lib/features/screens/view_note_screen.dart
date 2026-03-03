import 'package:flutter/material.dart';

class ViewNoteScreen extends StatelessWidget {
  const ViewNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: isDark
            ? theme.scaffoldBackgroundColor.withValues(alpha: 0.8)
            : theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 20,
        ),
        title: const Text(
          'Project Alpha...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 24),
            onPressed: () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project Alpha Roadmap',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last updated: Feb 15, 2024',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: isDark ? Colors.white10 : Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.content_copy, size: 16),
                  label: const Text(
                    'Copy All',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Phase 1: Security Audit. Our primary focus is completing the comprehensive penetration testing across all cloud environments. All API endpoints must be validated against the new Zero-Trust architecture.\n\nPhase 2: Beta Launch. Scheduled for late Q3. We will invite the first cohort of 500 power users to test the stability of the core ledger components. Detailed infrastructure review completed. All security protocols are now in place for the upcoming quarter.\n\nPhase 3: Public Release. Following the audit and successful beta feedback loops, the global rollout will begin. Final localization for 12 languages is currently underway.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTagChip(context, 'Work', Colors.blue),
                  _buildTagChip(context, 'Urgent', Colors.red),
                  _buildTagChip(context, 'Internal', Colors.amber),
                ],
              ),
              const SizedBox(height: 48), // Bottom safe space
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

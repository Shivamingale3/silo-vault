import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silo_vault/core/providers/update_provider.dart';
import 'package:silo_vault/core/theme/theme_provider.dart';
import 'package:silo_vault/core/enums/app_enums.dart';

class UpdateScreen extends ConsumerStatefulWidget {
  const UpdateScreen({super.key});

  @override
  ConsumerState<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProvider);
    final themeMode = ref.watch(themeProvider);
    final isAmoled = themeMode == AppThemeMode.amoled;
    final isDark = themeMode == AppThemeMode.dark || isAmoled;

    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = isAmoled
        ? Colors.black
        : Theme.of(context).scaffoldBackgroundColor;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // Background Decorative Elements
            Positioned(
              top: -100,
              right: -100,
              child: _CircularGlow(
                color: primaryColor.withOpacity(0.15),
                size: 300,
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _CircularGlow(
                color: primaryColor.withOpacity(0.1),
                size: 200,
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        _HeaderSection(
                          version:
                              updateState.updateInfo?.tagName ?? 'New Version',
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'WHAT\'S NEW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _ChangelogCard(
                            changelog:
                                updateState.updateInfo?.changelog ??
                                'Check out the latest features and fixes.',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (updateState.status == UpdateStatus.error) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    updateState.error ?? 'An error occurred',
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _UpdateActionSection(
                          status: updateState.status,
                          progress: updateState.progress,
                          onUpdate: () => ref
                              .read(updateProvider.notifier)
                              .downloadAndInstall(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String version;
  const _HeaderSection({required this.version});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            'UPDATE AVAILABLE',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A newer version of Silo Vault is ready.',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Version $version',
          style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ChangelogCard extends StatelessWidget {
  final String changelog;
  final bool isDark;

  const _ChangelogCard({required this.changelog, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Text(
            changelog,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.6,
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateActionSection extends StatelessWidget {
  final UpdateStatus status;
  final double progress;
  final VoidCallback onUpdate;

  const _UpdateActionSection({
    required this.status,
    required this.progress,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloading = status == UpdateStatus.downloading;
    final isReady = status == UpdateStatus.ready;
    final isError = status == UpdateStatus.error;

    String buttonText = 'Update Now';
    if (isDownloading) buttonText = 'Downloading...';
    if (isReady) buttonText = 'Install Now';
    if (isError) buttonText = 'Try Again';

    return Column(
      children: [
        if (isDownloading) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 24),
        ],
        if (isReady) ...[
          const Text(
            'Download Complete',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 60,
          child: _PulseButton(
            isPulsing: isReady,
            child: ElevatedButton(
              onPressed: isDownloading ? null : onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: isReady
                    ? Colors.green
                    : (isError ? Colors.red : Theme.of(context).primaryColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseButton extends StatefulWidget {
  final Widget child;
  final bool isPulsing;

  const _PulseButton({required this.child, required this.isPulsing});

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_PulseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !oldWidget.isPulsing) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPulsing && oldWidget.isPulsing) {
      _controller.stop();
      _controller.animateTo(0, duration: const Duration(milliseconds: 200));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPulsing) return widget.child;
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class _CircularGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _CircularGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

/// Widget that handles back button press and shows exit confirmation dialog
class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;
  final bool allowExit;

  const BackButtonHandler({
    Key? key,
    required this.child,
    this.onBackPressed,
    this.allowExit = true,
  }) : super(key: key);

  Future<bool> _onBackPressed(BuildContext context) async {
    if (onBackPressed != null) {
      onBackPressed!();
      return false;
    }

    if (!allowExit) {
      return false;
    }

    final shouldExit =
        await showDialog<bool>(
          context: context,
          barrierColor: Colors.black87,
          builder: (context) => const _ExitConfirmationDialog(),
        ) ??
        false;

    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed(context);
        }
      },
      child: child,
    );
  }
}

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NeonTheme.darkBg2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: NeonTheme.neonCyanBorder(2),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [NeonTheme.darkBg2, NeonTheme.darkBg3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: NeonTheme.neonCyan, width: 2),
          boxShadow: NeonTheme.neonCyanShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NeonTheme.neonCyan.withOpacity(0.2),
                border: Border.all(color: NeonTheme.neonCyan, width: 2),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: NeonTheme.neonCyan,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            ResponsiveHeading(
              'Exit App?',
              color: NeonTheme.neonCyan,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ResponsiveBody(
              'Do you want to close Run Reward Rift?',
              textAlign: TextAlign.center,
              color: NeonTheme.textLight,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: NeonTheme.neonPurple,
                          width: 2,
                        ),
                        color: NeonTheme.neonPurple.withOpacity(0.1),
                      ),
                      child: Center(
                        child: ResponsiveBody(
                          'Continue',
                          color: NeonTheme.neonPurple,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeonTheme.neonPink, width: 2),
                        gradient: LinearGradient(
                          colors: [
                            NeonTheme.neonPink.withOpacity(0.3),
                            NeonTheme.neonMagenta.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Center(
                        child: ResponsiveBody(
                          'Close App',
                          color: NeonTheme.neonPink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

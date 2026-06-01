import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class PixelButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.fontSize = 9,
    this.padding,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppTheme.primaryRed;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 4 : 0,
          _pressed ? 4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: const Border(
            top: BorderSide(color: AppTheme.textDark, width: 3),
            left: BorderSide(color: AppTheme.textDark, width: 3),
            right: BorderSide(color: AppTheme.textDark, width: 3),
            bottom: BorderSide(color: AppTheme.textDark, width: 3),
          ),
          boxShadow: _pressed
              ? []
              : const [
                  BoxShadow(
                    color: AppTheme.textDark,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: widget.padding ??
            const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Center(
          child: Text(
            widget.label,
            style: GoogleFonts.pressStart2p(
              fontSize: widget.fontSize,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

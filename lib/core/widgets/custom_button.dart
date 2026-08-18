import 'package:finalproject/core/theme/text_styles.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.textColor,
    required this.isLoading,
    this.width,
    required this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double buttonSize = widget.width ?? screenSize.width * 0.8;
    final double responsiveHeight = (screenSize.height * 0.06).clamp(54.0, 64.0);

    final primaryColor = widget.color ?? context.styles.primaryColor;

    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered && !widget.isLoading ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: buttonSize,
            height: responsiveHeight,
            decoration: BoxDecoration(
              gradient: widget.color != null
                  ? null
                  : LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: widget.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: _isHovered ? 0.45 : 0.28),
                  blurRadius: _isHovered ? 24 : 16,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.textColor ?? Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          size: 22,
                          color: widget.textColor ?? Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.text,
                          style: AppTextStyles.size16W600.copyWith(
                            color: widget.textColor ?? Colors.white,
                            fontSize: screenSize.width < 350 ? 14 : 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

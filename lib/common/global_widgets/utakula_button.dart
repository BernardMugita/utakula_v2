import 'package:flutter/material.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

enum UtakulaButtonVariant { primary, secondary, outline, text }

enum UtakulaButtonSize { small, medium, large }

class UtakulaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final UtakulaButtonVariant variant;
  final UtakulaButtonSize size;
  final IconData? icon;
  final bool iconRight;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? elevation;
  final Widget? loadingWidget;

  const UtakulaButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = UtakulaButtonVariant.primary,
    this.size = UtakulaButtonSize.medium,
    this.icon,
    this.iconRight = false,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.elevation,
    this.loadingWidget,
  }) : super(key: key);

  @override
  State<UtakulaButton> createState() => _UtakulaButtonState();
}

class _UtakulaButtonState extends State<UtakulaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    // Get dimensions based on size
    final dimensions = _getDimensions();

    // Get colors based on variant
    final colors = _getColors(isDisabled);

    return GestureDetector(
      onTapDown: isDisabled ? null : _handleTapDown,
      onTapUp: isDisabled ? null : _handleTapUp,
      onTapCancel: isDisabled ? null : _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: dimensions['height'],
          child: ElevatedButton(
            onPressed: isDisabled ? null : widget.onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.disabled)) {
                  return colors['background']!.withOpacity(0.5);
                }
                if (states.contains(WidgetState.pressed)) {
                  return colors['background']!.withOpacity(0.8);
                }
                return colors['background']!;
              }),
              foregroundColor: WidgetStatePropertyAll(colors['text']),
              elevation: WidgetStatePropertyAll(
                widget.elevation ??
                    (widget.variant == UtakulaButtonVariant.text ? 0 : 2),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dimensions['radius']!),
                  side: widget.variant == UtakulaButtonVariant.outline
                      ? BorderSide(color: colors['border']!, width: 2)
                      : BorderSide.none,
                ),
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: dimensions['paddingH']!,
                  vertical: dimensions['paddingV']!,
                ),
              ),
              overlayColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.1);
                }
                return Colors.transparent;
              }),
            ),
            child: widget.isLoading
                ? _buildLoadingWidget(colors['text']!)
                : _buildContent(dimensions['fontSize']!),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(Color textColor) {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(textColor),
      ),
    );
  }

  Widget _buildContent(double fontSize) {
    if (widget.icon == null) {
      return Text(
        widget.text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: ThemeUtils.$fixedTextColor,
          letterSpacing: 0.5,
        ),
      );
    }

    final iconWidget = Icon(
      widget.icon,
      size: fontSize + 2,
      color: ThemeUtils.$fixedTextColor,
    );

    final textWidget = Text(
      widget.text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: ThemeUtils.$fixedTextColor,
        letterSpacing: 0.5,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.iconRight
          ? [textWidget, const SizedBox(width: 8), iconWidget]
          : [iconWidget, const SizedBox(width: 8), textWidget],
    );
  }

  Map<String, double> _getDimensions() {
    switch (widget.size) {
      case UtakulaButtonSize.small:
        return {
          'height': 36.0,
          'paddingH': 12.0,
          'paddingV': 8.0,
          'fontSize': 13.0,
          'radius': 8.0,
        };
      case UtakulaButtonSize.large:
        return {
          'height': 56.0,
          'paddingH': 24.0,
          'paddingV': 16.0,
          'fontSize': 16.0,
          'radius': 14.0,
        };
      case UtakulaButtonSize.medium:
      default:
        return {
          'height': 48.0,
          'paddingH': 20.0,
          'paddingV': 12.0,
          'fontSize': 15.0,
          'radius': 12.0,
        };
    }
  }

  Map<String, Color> _getColors(bool isDisabled) {
    if (isDisabled) {
      return {
        'background': Colors.grey.shade400,
        'text': Colors.grey.shade600,
        'border': Colors.grey.shade400,
      };
    }

    switch (widget.variant) {
      case UtakulaButtonVariant.primary:
        return {
          'background':
              widget.backgroundColor ?? ThemeUtils.primaryColor(context),
          'text': widget.textColor ?? ThemeUtils.blacks(context),
          'border': widget.borderColor ?? ThemeUtils.primaryColor(context),
        };
      case UtakulaButtonVariant.secondary:
        return {
          'background':
              widget.backgroundColor ?? ThemeUtils.secondaryColor(context),
          'text': widget.textColor ?? ThemeUtils.primaryColor(context),
          'border': widget.borderColor ?? ThemeUtils.secondaryColor(context),
        };
      case UtakulaButtonVariant.outline:
        return {
          'background': widget.backgroundColor ?? Colors.transparent,
          'text': widget.textColor ?? ThemeUtils.primaryColor(context),
          'border': widget.borderColor ?? ThemeUtils.primaryColor(context),
        };
      case UtakulaButtonVariant.text:
        return {
          'background': widget.backgroundColor ?? Colors.transparent,
          'text': widget.textColor ?? ThemeUtils.blacks(context),
          'border': widget.borderColor ?? Colors.transparent,
        };
    }
  }
}

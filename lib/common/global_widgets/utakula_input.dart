import 'package:flutter/material.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class UtakulaInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final bool showPasswordToggle;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? borderColor;

  const UtakulaInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<UtakulaInput> createState() => _UtakulaInputState();
}

class _UtakulaInputState extends State<UtakulaInput> {
  bool _isPasswordVisible = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = widget.textColor ?? ThemeUtils.secondaryColor(context);
    final effectiveHintColor =
        widget.hintColor ?? ThemeUtils.secondaryColor(context).withOpacity(0.7);
    final effectiveIconColor = widget.iconColor ?? ThemeUtils.secondaryColor(context);
    final effectiveBorderColor =
        widget.borderColor ?? ThemeUtils.secondaryColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: ThemeUtils.primaryColor(context).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_isPasswordVisible,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        focusNode: _focusNode,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: effectiveHintColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: widget.fillColor ?? Colors.white.withOpacity(0.1),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon,
            color: effectiveIconColor,
            size: 22,
          )
              : null,
          suffixIcon: widget.showPasswordToggle
              ? GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: effectiveIconColor,
              size: 22,
            ),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: effectiveBorderColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ThemeUtils.$error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ThemeUtils.$error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
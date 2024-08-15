import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isActive = true,
    this.isDisabled = false,
    this.buttonStyle,
    this.width,
    this.buttonActiveColor,
    this.buttonInActiveColor,
  });

  final String text;
  final VoidCallback onTap;
  final bool? isActive;
  final bool? isDisabled;
  final TextStyle? buttonStyle;
  final Color? buttonActiveColor;
  final Color? buttonInActiveColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isDisabled == null || isDisabled == false) ? onTap : null,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: SportifindTheme.bluePurple,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: (isActive == false && isDisabled == false) ? Border.all(color: SportifindTheme.grey, width: 2) : null,
        ),
        child: Text(
          text,
          style: SportifindTheme.textWhite,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

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

  Color _getButtonColor() {
    if (isActive == true && isDisabled == false) {
      return buttonActiveColor ?? SportifindTheme.grey;
    } else if (isActive == false && isDisabled == false) {
      return Colors.white;
    } else {
      return buttonInActiveColor ?? SportifindTheme.darkGrey;
    }
  }

  Color _getTextColor() {
    if (isActive == true && isDisabled == false) {
      return SportifindTheme.darkText;
    } else if (isActive == false && isDisabled == false) {
      return buttonActiveColor ?? Colors.teal;
    } else {
      return SportifindTheme.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).textTheme;

    return InkWell(
      onTap: (isDisabled == null || isDisabled == false) ? onTap : null,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _getButtonColor(),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: (isActive == false && isDisabled == false) ? Border.all(color: SportifindTheme.grey, width: 2) : null,
        ),
        child: Text(
          text,
          style: buttonStyle ?? themeData.labelLarge!.copyWith(color: _getTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

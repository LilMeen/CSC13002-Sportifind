import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class BluePurpleWhiteIconNormalButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final String type;
  final String size;

  const BluePurpleWhiteIconNormalButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.type = 'round', // round, round square
    this.size = 'normal', // large, normal, small
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: size == 'small' ? 20 : 24),
      label: Text(
        text,
        style: size == 'large'
            ? SportifindTheme.largeTextIconButton
            : size == 'small'
                ? SportifindTheme.smallTextIconButton
                : SportifindTheme.normalTextIconButton,
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: SportifindTheme.bluePurple,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: type == 'round square'
              ? BorderRadius.circular(8.0)
              : BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

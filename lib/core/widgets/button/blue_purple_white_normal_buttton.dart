import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class BluePurpleWhiteNormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String type;

  const BluePurpleWhiteNormalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = 'round', // round, round square
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: SportifindTheme.bluePurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: type == 'round square'
              ? BorderRadius.circular(8.0)
              : BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
      child: Text(
        text,
        style: SportifindTheme.normalTextButton,
      ),
    );
  }
}

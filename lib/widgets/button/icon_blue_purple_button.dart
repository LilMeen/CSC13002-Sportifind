import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class BluePurpleWhiteWithIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final String type;
  final String size;

  const BluePurpleWhiteWithIconButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.type = 'round',
    this.size = 'average'
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.map_outlined),
      label: Text(text, style: size == 'large' ? SportifindTheme.largeTextIconButton: size == 'small' ? SportifindTheme.smallTextIconButton: SportifindTheme.averageTextIconButton),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: SportifindTheme.bluePurple,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: type == 'round square'
              ? BorderRadius.circular(8.0)
              : BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

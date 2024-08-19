import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class BluePurpleWhiteIconLoadingButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final Future<void> Function() onPressed;
  final String type;
  final String size;

  const BluePurpleWhiteIconLoadingButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.type = 'round', // round, round square
    this.size = 'normal', // large, normal, small
  });

  @override
  State<BluePurpleWhiteIconLoadingButton> createState() => _BluePurpleWhiteIconLoadingButtonState();
}

class _BluePurpleWhiteIconLoadingButtonState extends State<BluePurpleWhiteIconLoadingButton> {
  bool isLoading = false;

  Future<void> _handlePressed() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onPressed();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: isLoading ? null : _handlePressed,
      icon: isLoading
          ? SizedBox(
              height: widget.size == 'small' ? 20 : 24,
              width: widget.size == 'small' ? 20 : 24,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.0,
              ),
            )
          : Icon(widget.icon, size: widget.size == 'small' ? 20 : 24),
      label: isLoading
          ? const SizedBox.shrink()
          : Text(
              widget.text,
              style: widget.size == 'large'
                  ? SportifindTheme.largeTextIconButton
                  : widget.size == 'small'
                      ? SportifindTheme.smallTextIconButton
                      : SportifindTheme.normalTextIconButton,
            ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: SportifindTheme.bluePurple,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: widget.type == 'round square'
              ? BorderRadius.circular(8.0)
              : BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

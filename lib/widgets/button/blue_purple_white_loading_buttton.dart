import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class BluePurpleWhiteLoadingButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final String type;

  const BluePurpleWhiteLoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = 'round', // round, round square
  });

  @override
  State<BluePurpleWhiteLoadingButton> createState() => _BluePurpleWhiteLoadingButtonState();
}

class _BluePurpleWhiteLoadingButtonState extends State<BluePurpleWhiteLoadingButton> {
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
    return TextButton(
      onPressed: isLoading ? null : _handlePressed,
      style: TextButton.styleFrom(
        backgroundColor: SportifindTheme.bluePurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: widget.type == 'round square'
              ? BorderRadius.circular(8.0)
              : BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
      child: isLoading
          ? SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: SportifindTheme.bluePurple,
                strokeWidth: 3.0,
              ),
            )
          : Text(
              widget.text,
              style: SportifindTheme.normalTextButton,
            ),
    );
  }
}

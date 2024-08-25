import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class CurrentLocationIconButton extends StatelessWidget {
  final bool isLoading;
  final double size;
  final VoidCallback? onPressed;

  const CurrentLocationIconButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
          width: size + 18,
          height: size + 18,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
                backgroundColor: SportifindTheme.bluePurple,
                color: Colors.white,
              ),
          ),
        )
        : IconButton(
            icon: Icon(
              Icons.my_location,
              color: SportifindTheme.bluePurple,
              size: size,
            ),
            onPressed: onPressed,
            tooltip: 'Get current location',
          );
  }
}

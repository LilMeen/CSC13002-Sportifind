import 'package:flutter/material.dart';

class CurrentLocationIconButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const CurrentLocationIconButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator(
            backgroundColor: Colors.teal,
            color: Colors.white,
          )
        : IconButton(
            icon: const Icon(
              Icons.my_location,
              color: Colors.teal,
            ),
            onPressed: onPressed,
            tooltip: 'Get current location',
          );
  }
}

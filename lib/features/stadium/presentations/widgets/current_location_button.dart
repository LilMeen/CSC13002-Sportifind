import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const CurrentLocationButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          shadowColor: Colors.black,
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                backgroundColor: Colors.teal,
                color: Colors.white,
              )
            : const Icon(
                Icons.my_location,
                size: 23,
              ),
      ),
    );
  }
}

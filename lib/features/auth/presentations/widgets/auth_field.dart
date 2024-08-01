import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class AuthField extends StatelessWidget {
  final String label;
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;

  const AuthField ({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.obscureText,
    required this.validator,
  });


  @override
  Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:[
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            label,
            style: SportifindTheme.headline,
          ),
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.bottom,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintText: hintText,
          hintStyle: SportifindTheme.greyTitle,
          filled: true,
          fillColor: Colors.white70,
          prefixIcon: icon,
        ),
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        validator: validator,
        obscureText: obscureText,
      ),
    ],
  );
  }
}
//value == null || value.trim().isEmpty || !value.contains('@') 'Invalid email!'


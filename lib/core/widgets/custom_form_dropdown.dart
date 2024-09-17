import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/widgets/form/custom_form.dart';

class CustomFormDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color fillColor;
  final bool isLoading;
  final String validatorText;

  const CustomFormDropdown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.validatorText,
    this.fillColor = SportifindTheme.whiteSmoke,
    this.isLoading = false,
  });

  @override
  State<CustomFormDropdown> createState() => _CustomFormDropdownState();
}

class _CustomFormDropdownState extends State<CustomFormDropdown> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
          hint: Text(
            widget.hint,
            style: SportifindTheme.smallTextSmokeScreen,
          ),
          isExpanded: true,
          items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(
                    widget.hint,
                    style: SportifindTheme.smallTextSmokeScreen,
                  ),
                )
              ] +
              widget.items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: SizedBox(
                    width: constraints.maxWidth -
                        48, // Adjust this value as needed
                    child: Text(
                      item,
                      style: SportifindTheme.smallTextBlack,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                );
              }).toList(),
          onChanged: widget.isLoading ? null : widget.onChanged,
          decoration: CustomForm().customInputDecoration('').copyWith(
            filled: true,
            fillColor: widget.fillColor,
          ),
          dropdownColor: widget.fillColor,
          icon: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: SportifindTheme.bluePurple,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.expand_more,
                  color: Colors.black,
                ),
          iconSize: 24,
          validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.validatorText;
        }
        return null;
      },
        );
      },
    );
  }
}

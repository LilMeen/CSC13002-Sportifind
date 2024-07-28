import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class StadiumFormDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color fillColor;
  final bool isLoading;
  final String validatorText;

  const StadiumFormDropdown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.validatorText,
    this.fillColor = Colors.white,
    this.isLoading = false,
  });

  @override
  State<StadiumFormDropdown> createState() => _StadiumFormDropdownState();
}

class _StadiumFormDropdownState extends State<StadiumFormDropdown> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
          hint: Text(widget.hint),
          isExpanded: true,
          items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(
                    widget.hint,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
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
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                );
              }).toList(),
          onChanged: widget.isLoading ? null : widget.onChanged,
          dropdownColor: Colors.white,
          icon: widget.isLoading
              ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                    backgroundColor: SportifindTheme.bluePurple3,
                    color: Colors.white,
                  ),
              )
              : const Icon(Icons.arrow_drop_down),
          iconSize: 20,
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

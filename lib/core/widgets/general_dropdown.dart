import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class GeneralDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color fillColor;
  final bool isLoading;

  const GeneralDropdown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.fillColor = SportifindTheme.whiteSmoke,
    this.isLoading = false,
  });

  @override
  State<GeneralDropdown> createState() => _GeneralDropdownState();
}

class _GeneralDropdownState extends State<GeneralDropdown> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
          hint: Text(widget.hint),
          style: SportifindTheme.normalTextSmokeScreen,
          items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(
                    widget.hint,
                    style: SportifindTheme.normalTextSmokeScreen,
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
                      style: SportifindTheme.normalTextSmokeScreen,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                );
              }).toList(),
          onChanged: widget.isLoading ? null : widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(width: 3, color: SportifindTheme.bluePurple),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          ),
          dropdownColor: widget.fillColor,
          icon: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.teal,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 4,
        );
      },
    );
  }
}

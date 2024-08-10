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
          hint: Text(
            widget.hint,
            style: SportifindTheme.normalTextSmokeScreen,
          ),
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
                      style: SportifindTheme.normalTextBlack,
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
              borderSide: BorderSide(
                color: SportifindTheme.bluePurple,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: SportifindTheme.bluePurple,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: SportifindTheme.bluePurple,
                width: 1.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
                  color: SportifindTheme.smokeScreen,
                ),
          iconSize: 24,
          elevation: 4,
        );
      },
    );
  }
}

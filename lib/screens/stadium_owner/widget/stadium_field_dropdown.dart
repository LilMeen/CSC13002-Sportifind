import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class StadiumFieldDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const StadiumFieldDropdown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  State<StadiumFieldDropdown> createState() => _StadiumFieldDropdownState();
}

class _StadiumFieldDropdownState extends State<StadiumFieldDropdown> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
          hint: Text(
            widget.hint,
            style: const TextStyle(
              color: Colors.black45,
            ),
          ),
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
                      style: TextStyle(
                        color: SportifindTheme.bluePurple,
                      ),
                    ),
                  ),
                );
              }).toList(),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
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
                color:
                    SportifindTheme.bluePurple,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color:
                    SportifindTheme.bluePurple,
                width: 1.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          ),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 4,
        );
      },
    );
  }
}

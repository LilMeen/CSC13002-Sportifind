import 'package:flutter/material.dart';

class GeneralDropdown extends StatefulWidget {
  final String selectedValue;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color fillColor;

  const GeneralDropdown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.fillColor = Colors.white,
  });

  @override
  State<GeneralDropdown> createState() => _GeneralDropdownState();
}

class _GeneralDropdownState extends State<GeneralDropdown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
        hint: Text(widget.hint),
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
                child: Text(item),
              );
            }).toList(),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 4,
      ),
    );
  }
}




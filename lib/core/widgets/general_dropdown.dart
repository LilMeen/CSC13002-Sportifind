import 'package:flutter/material.dart';

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
    this.fillColor = Colors.white,
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
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
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

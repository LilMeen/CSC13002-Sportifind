import 'package:flutter/material.dart';
import 'package:sportifind/models/field_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class FieldPicker extends StatefulWidget {
  FieldPicker({
    super.key,
    required this.height,
    required this.width,
    required this.selectedField,
    required this.fields,
    required this.func,
  });

  final double height;
  final double width;
  String? selectedField;
  List<FieldData> fields;
  final void Function(String) func;

  @override
  State<FieldPicker> createState() => _FieldPickerState();
}

class _FieldPickerState extends State<FieldPicker> {
  @override
  Widget build(BuildContext context) {
    widget.fields = List.from(widget.fields)..sort((a, b) => a.numberId.compareTo(b.numberId));
    return Row(
      children: [
        const Text(
          "Field",
          style: SportifindTheme.display2,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: SportifindTheme.grey,
          ),
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(5.0),
            value: widget.selectedField,
            isExpanded: true,
            items: widget.fields.map((FieldData item) {
              return DropdownMenuItem<String>(
                value: item.numberId.toString(),
                child: widget.selectedField == null ? Text("Choose a field") : Text('${item.numberId} ${item.type}'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  widget.selectedField = value;
                  widget.func(value);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

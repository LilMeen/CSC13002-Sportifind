import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

// ignore: must_be_immutable
class FieldPicker extends StatefulWidget {
  FieldPicker({
    super.key,
    this.func,
    required this.height,
    required this.width,
    required this.selectedField,
    required this.numberOfField,
  });
  final double height;
  final double width;
  String? selectedField;
  int numberOfField;
  final dynamic func;

  @override
  State<StatefulWidget> createState() => _FieldPickerState();
}

class _FieldPickerState extends State<FieldPicker> {
  @override
  Widget build(BuildContext context) {
    List<String> fieldList =
        List<String>.filled(widget.numberOfField, '0', growable: false);
    for (int i = 0; i < widget.numberOfField; ++i) {
      fieldList[i] = (i + 1).toString();
    }
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
            color: SportifindTheme.nearlyGreen,
          ),
          child: DropdownButton(
            borderRadius: BorderRadius.circular(5.0),
            value: widget.selectedField,
            isExpanded: true,
            items: fieldList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                widget.selectedField = value;
                widget.func(value);
              });
            },
          ),
        ),
      ],
    );
  }
}

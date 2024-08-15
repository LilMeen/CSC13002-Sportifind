import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';


// ignore: must_be_immutable
class FieldPicker extends StatefulWidget {
  FieldPicker({
    super.key,
    required this.height,
    required this.width,
    required this.selectedField,
    required this.fields,
    required this.selectedFieldType,
    required this.func,
  });

  final double height;
  final double width;
  int? selectedField;
  String selectedFieldType;
  List<FieldEntity> fields;
  List<FieldEntity> fieldsWithType = [];
  final void Function(int) func;

  @override
  State<FieldPicker> createState() => _FieldPickerState();
}

class _FieldPickerState extends State<FieldPicker> {
  @override
  void initState() {
    super.initState();
    _populateFieldsWithType();
  }

  @override
  void didUpdateWidget(covariant FieldPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFieldType != widget.selectedFieldType) {
      setState(() {
        widget.func(widget.selectedField!);
      });
    }
    _populateFieldsWithType();
  }

  void _populateFieldsWithType() {
    // Clear the list to avoid duplicates
    widget.fieldsWithType.clear();

    for (var i = 0; i < widget.fields.length; ++i) {
      if (widget.fields[i].type == widget.selectedFieldType) {
        widget.fieldsWithType.add(widget.fields[i]);
      }
    }

    // Sort the list after populating it
    widget.fieldsWithType.sort((a, b) => a.numberId.compareTo(b.numberId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Field",
          style: SportifindTheme.body,
        ),
        const SizedBox(height: 5,),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: 50,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SportifindTheme.bluePurple,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(5.0),
              value: widget.selectedField?.toString(),
              style: SportifindTheme.textWhite,
              dropdownColor: SportifindTheme.bluePurple,
              isExpanded: true,
              items: widget.fieldsWithType.map((FieldEntity item) {
                return DropdownMenuItem<String>(
                  value: item.numberId.toString(),
                  child: Center(
                      child: Text(
                    '${item.numberId}',
                    style: SportifindTheme.textWhite,
                  )),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    widget.selectedField = int.parse(value);
                    widget.func(widget.selectedField!);
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

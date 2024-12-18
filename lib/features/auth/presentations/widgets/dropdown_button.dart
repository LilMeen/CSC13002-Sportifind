import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class Dropdown extends StatefulWidget {
  final String type;
  final double horizontalPadding;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController textController;

  const Dropdown({
    required this.type,
    required this.textController,
    this.horizontalPadding = 5.0,
    this.onSaved,
    super.key
  });

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  String? value;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> cities = ['Ho Chi Minh', 'Ha Noi', 'Da Nang'];
  final List<String> districts = ['District 1', 'District 2', 'District 3'];

  List<String> getItems() {
    switch (widget.type) {
      case 'Gender':
        return genders;
      case 'City/Province':
        return cities;
      case 'District':
        return districts;
      default:
        return [];
    }
  }

  String getHint() {
    switch (widget.type) {
      case 'Gender':
        return 'Select gender';
      case 'City/Province':
        return 'Select city';
      case 'District':
        return 'Select district';
      default:
        return 'Select';
    }
  }

  @override
  void initState() {
    super.initState();
    value = widget.textController.text.isNotEmpty ? widget.textController.text : null;
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = getItems();
    String hint = getHint();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          items: items.map(buildMenuItem).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: widget.horizontalPadding),
                child: Text(
                  item,
                  style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          onChanged: (newValue) {
            setState(() {
              value = newValue;
              widget.textController.text = newValue!;
            });
          },
          onSaved: widget.onSaved,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: Text(
              hint,
              style: SportifindTheme.titleChart.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: const Icon(Icons.arrow_drop_down, color: Colors.black),
          ),
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
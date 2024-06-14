import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String type;

  Dropdown({required this.type});
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
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
        return 'Gender';
      case 'City/Province':
        return 'City';
      case 'District':
        return 'District';
      default:
        return 'Select';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = getItems();
    String hint = getHint();

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 33, 33, 33),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Colors.white),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() => this.value = value),
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            hint,
            style: const TextStyle(
              color: Color.fromARGB(255, 207, 205, 205),
            ),
          ),
        ),
        underline: Container(),
        icon: const Align(
          alignment: Alignment.center, //padding: const EdgeInsets.all(),
          child: Icon(Icons.arrow_drop_down),
        ),
        iconEnabledColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String items) {
    return DropdownMenuItem(
      value: items,
      child: Text(items),
    );
  }
}

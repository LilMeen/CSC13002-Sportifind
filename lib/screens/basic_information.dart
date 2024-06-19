import 'package:flutter/material.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({super.key});


  String getHint(String type) {
    switch (type) {
      case 'Name':
        return 'Enter your name';
      case 'Date Of Birth':
        return 'dd/mm/yy';
      case 'Phone number':
        return 'Enter your phone number';
      case 'Gender':
        return 'Gender';
      case 'City/Province':
        return 'Ho Chi Minh';
      case 'District':
        return 'District';
      default:
        return 'Enter';
    }
  }

  Widget _buildSection(String type) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ]),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: 290,
        height: 40,
        child: TextFormField(
            decoration: InputDecoration(
                hintText: getHint(type),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 2, 183, 144)),
                )),
            style: const TextStyle(color: Colors.white)),
      ),
    ]);
  }

  Widget _buildDropdownSection(String type) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ]),
      ),
      const SizedBox(height: 12),
      SizedBox(
          width: type == "District" ? 290 : 137,
          height: 40,
          child: _buildDropDown(type)),
    ]);
  }

  Widget _nextButton() {
    return SizedBox(
      width: 80,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.tealAccent),
            shadowColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 213, 211, 211))),
        child: const Text(
          'Next',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDropDown(String type) {
    return Dropdown(type: type);
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Basic Information",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          elevation: 0.0,
        ),
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        body: Container(
          child: 
              SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 27),
                _buildSection('Name'),
                const SizedBox(height: 12),
                _buildSection('Date Of Birth'),
                const SizedBox(height: 12),
                _buildSection('Phone Number'),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  _buildDropdownSection('Gender'),
                  const SizedBox(width: 15),
                  _buildDropdownSection('City/Province'),
                ]),
                const SizedBox(height: 12),
                _buildDropdownSection('District'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 210),
                  child: _nextButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

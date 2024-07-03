import 'package:flutter/material.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:sportifind/widgets/setting.dart';
import 'package:sportifind/widgets/number_wheel.dart';
import 'package:image_picker/image_picker.dart';


final _formKey = GlobalKey<FormState>();

class EditInformationScreen extends StatefulWidget {
  const EditInformationScreen({super.key});

  @override
  EditInformationState createState() => EditInformationState();
}

class EditInformationState extends State<EditInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredDob = '';
  var _enteredGender = '';
  var _enteredCity = '';
  var _enteredDistrict = '';
  var _enteredHeight = '';
  var _enteredWeight = '';
  var _enterStat = '';

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _done() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingScreen(),
        ),
      );
    }
  }

  String getHint(String type) {
    switch (type) {
      case 'Name':
        return 'Enter your name';
      case 'Date Of Birth':
        return 'dd/mm/yy';
      case 'Phone Number':
        return 'Enter your phone number';
      case 'Height':
        return 'meters';
      case 'Weight':
        return 'kilogram';
      default:
        return 'Enter';
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalInput = DateTime(date.day, date.month, date.year);
      final parsedInput = DateTime.parse(input);
      return originalInput == parsedInput;
    } catch (e) {
      return false;
    }
  }

  bool isValidName(String input) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(input);
  }

  bool isValidPhoneNumber(String input) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(input);
  }

  Widget _buildSection(String type, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: type == "Height" || type == "Weight" ? 137 : 290,
          height: 70,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: getHint(type),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 2, 183, 144),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (type == "Height" || type == "Weight") {
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
              }
              if (type == "Date Of Birth") {
                if (!isValidDate(value)) {
                  return 'Please enter a valid date (DD/MM/YYYY)';
                }
              }
              if (type == "Name") {
                if (!isValidName(value) || value.trim().length < 5) {
                  return 'Please enter a valid name (at least 5 words)';
                }
              }
              if (type == "Phone Number") {
                if (!isValidPhoneNumber(value)) {
                  return 'Please enter a valid phone number';
                }
              }
              return null;
            },
            onSaved: (value) {
              switch(type){
                case 'Name':
                _enteredName = value!;
                break;
                case 'Date Of Birth':
                _enteredDob = value!;
                break;
                case 'Phone Number':
                _enteredPhone = value!;
                break;
                case 'Gender':
                _enteredPhone = value!;
                break;
                case 'City/Province':
                _enteredCity = value!;
                break;
                case 'District':
                _enteredDistrict = value!;
                break;
                case 'Height':
                _enteredHeight = value!;
                break;
                case 'Weight':
                _enteredWeight = value!;
                break;
              }
            }
          ),
        ),
      ],
    );
  }


  Widget _buildDropdownSection(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: type == "District" ? 290 : 137,
          height: 50,
          child: _buildDropDown(type),
        ),
      ],
    );
  }

  Widget _buildWheelSection(String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 137,
          height: 40,
          child: NumberWheel(),
        ),
      ],
    );
  }

  Widget _nextButton(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _done();
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.tealAccent),
          shadowColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 213, 211, 211),
          ),
        ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Information",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 27),
                _buildSection('Name', _nameController),
                const SizedBox(height: 12),
                _buildSection('Date Of Birth', _dateController),
                const SizedBox(height: 12),
                _buildSection('Phone Number', _phoneController),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDropdownSection('Gender'),
                    const SizedBox(width: 15),
                    _buildDropdownSection('City/Province'),
                  ],
                ),
                const SizedBox(height: 38),
                _buildDropdownSection('District'),
                const SizedBox(height: 38),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSection('Height', _heightController),
                      const SizedBox(width: 15),
                      _buildSection('Weight', _weightController),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWheelSection('PACE'),
                      const SizedBox(width: 15),
                      _buildWheelSection('DEF'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWheelSection('SHOOTING'),
                      const SizedBox(width: 15),
                      _buildWheelSection('PASS'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWheelSection('DRIVE'),
                      const SizedBox(width: 15),
                      _buildWheelSection('PHYSIC'),
                    ],
                  ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 210),
                  child: _nextButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:sportifind/screens/player/profile/widgets/number_wheel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _formKey = GlobalKey<FormState>();
final _firebase = FirebaseAuth.instance;

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
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();


  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredDob = '';
  var _enteredAddress = '';
  var _enteredHeight = '';
  var _enteredWeight = '';

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _done() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

    print(stats);
    //print(statConditioner.text);

      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': _enteredName,
          'phone': _enteredPhone,
          'dob': _enteredDob,
          'address': _enteredAddress,
          'gender': _genderController.text,
          'city': _cityController.text,
          'district': _districtController.text,
          'height': _enteredHeight,
          'weight': _enteredWeight,
          'stats' : stats,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlayerHomeScreen(),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to store data: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      case 'Address':
        return 'Enter your Address';
      case 'Height':
        return 'meters';
      case 'Weight':
        return 'kilogram';
      default:
        return 'Enter';
    }
  }

  bool isValidName(String input) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(input);
  }

  bool isValidPhoneNumber(String input) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(input);
  }

  Widget _buildSection(String type, TextEditingController controller) {
    double width = 290; // Default width

    if (type == "Date Of Birth") {
      width = 154;
    } else if (type == "Height" || type == "Weight") {
      width = 137;
    }

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
          width: width,
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
              // Additional validation logic
              return null;
            },
            onSaved: (value) {
              switch (type) {
                case 'Name':
                  _enteredName = value!;
                case 'Date Of Birth':
                  _enteredDob = value!;
                case 'Phone Number':
                  _enteredPhone = value!;
                case 'Address':
                  _enteredAddress = value!;
                case 'Height':
                  _enteredHeight = value!;
                case 'Weight':
                  _enteredWeight = value!;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection(String type, TextEditingController controller) {
  double width = 137; // Default width

  if (type == "Gender") {
    width = 120;
  } else if (type == "Date Of Birth") {
    width = 137;
  } else if (type == "District" || type == "City/Province") {
    width = 290;
  }

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
        width: width,
        height: 50,
        child: Dropdown(
          type: type,
          onSaved: (value){ controller.text = value ?? ''; print(controller.text);},          
        ),
      ),
    ],
  );
}

Map<String, int> stats = {
    'PACE': 0,
    'DEF': 0,
    'SHOOTING': 0,
    'PASS': 0,
    'DRIVE': 0,
    'PHYSIC': 0,
  };

void _handleSaved(String stat, int value) {
    setState(() {
      stats[stat] = value;
    });
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
        SizedBox(
          width: 137,
          height: 40,
          child: NumberWheel(onSaved: (value) => _handleSaved(type, value)),
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
                //const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _buildDropdownSection('Gender', _genderController),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: _buildSection('Date Of Birth', _dateController),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSection('Phone Number', _phoneController),
                const SizedBox(height: 14),
                _buildDropdownSection('City/Province', _cityController),
                const SizedBox(height: 38),
                _buildDropdownSection('District', _districtController),
                const SizedBox(height: 38),
                _buildSection('Address', _addressController),
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

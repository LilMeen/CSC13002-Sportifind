import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium_owner_home_screen.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:sportifind/widgets/date_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _formKey = GlobalKey<FormState>();

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  BasicInformationState createState() => BasicInformationState();
}

class BasicInformationState extends State<BasicInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  DateTime? selectedDate;
  DateTime? dob;


  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredDob = '';
  var _enteredAddress = '';

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _done() async{
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': _enteredName,
          'phone': _enteredPhone,
          'dob': _dateController.text,
          'address': _enteredAddress,
          'gender': _genderController.text,
          'city': _cityController.text,
          'district': _districtController.text,
        });

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
        if (snapshot['role'] == 'player') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerHomeScreen()));
        } else if (snapshot['role'] == 'stadium_owner') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StadiumOwnerHomeScreen()));
        }
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

  Widget _buildDobSection(String type, TextEditingController controller) {
  double width = 290; // Default width for Date Of Birth

  GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: <TextSpan>[
            TextSpan(text: type),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: width,
        child: FormField<String>(
          key: _fieldKey,
          validator: (value) {
            if (controller.text.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            setState(() {
                              controller.text = formattedDate;
                              _enteredDob = controller.text;
                            });
                            state.didChange(controller.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Remove background color
                          shadowColor: Colors.transparent, // Remove shadow
                          side: const BorderSide(
                            color: Colors.white, // Match the border color
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.text.isEmpty ? getHint(type) : controller.text,
                            style: TextStyle(
                              color: controller.text.isEmpty ? Colors.grey : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
          onSaved: (value) {
            controller.text = value ?? '';
          },
        ),
      ),
    ],
  );
}


  Widget _buildSection(String type, TextEditingController controller) {
  double width = 290; // Default width

  if (type == "Height" || type == "Weight") {
    width = 137;
  }

  GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: <TextSpan>[
            TextSpan(text: type),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: width,
        child: FormField<String>(
          key: _fieldKey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            if (type == "Height" || type == "Weight") {
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    TextFormField(
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
                        errorStyle: const TextStyle(height: 0), // Hide the default error message
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        switch (type) {
                          case 'Name':
                            _enteredName = value!;
                            break;
                          case 'Phone Number':
                            _enteredPhone = value!;
                            break;
                          case 'Address':
                            _enteredAddress = value!;
                            break;
                        }
                      },
                    ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
          onSaved: (value) {
            controller.text = value ?? '';
          },
        ),
      ),
    ],
  );
}

  Widget _buildDropdownSection(String type, TextEditingController controller) {
  double width = 290; // Default width
  GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: <TextSpan>[
            TextSpan(text: type),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: width,
        child: FormField<String>(
          key: _fieldKey,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a value';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dropdown(
                  type: type,
                  onSaved: (value) {
                    state.didChange(value);
                    controller.text = value ?? '';
                  },
                  horizontalPadding: 5.0,
                  textController: controller,
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
          onSaved: (value) {
            controller.text = value ?? '';
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: SingleChildScrollView(
        child: Center(
          //padding: const EdgeInsets.symmetric(horizontal: 120.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Basic Information',
                  style: TextStyle(color: Colors.white, fontSize: 27)
                ),
                const SizedBox(height: 27),
                _buildSection('Name', _nameController),
                const SizedBox(height: 16),
                _buildSection('Phone Number', _phoneController),
                const SizedBox(height: 16),
                _buildDropdownSection('Gender', _genderController),
                const SizedBox(height: 16),
                _buildDobSection('Date Of Birth', _dateController),
                const SizedBox(height: 16),
                _buildDropdownSection('City/Province', _cityController),
                const SizedBox(height: 16),
                _buildDropdownSection('District', _districtController),
                const SizedBox(height: 16),
                _buildSection('Address', _addressController),
                const SizedBox(height: 24),
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

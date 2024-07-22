import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:sportifind/screens/player/profile/widgets/number_wheel.dart';
import 'package:sportifind/screens/player/profile/widgets/pick_foot.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';
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
  final TextEditingController _footController = TextEditingController();

  String _selectedCity = '';
  String _selectedDistrict = '';
  static final Map<String, String> citiesNameAndId = {};

  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredDob = '';
  var _enteredAddress = '';
  var _enteredHeight = '';
  var _enteredWeight = '';
  bool _isDatePicked = false;

  late Future<DocumentSnapshot> userDataFuture;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    userDataFuture = getUserData();
  }

  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _dateController.text = userData['dob'] ?? '';
            _genderController.text = userData['gender'] ?? '';
            _cityController.text = userData['city'] ?? '';
            _districtController.text = userData['district'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _weightController.text = userData['weight'] ?? '';
            _heightController.text = userData['height'] ?? '';
            stats = Map<String, int>.from(userData['stats'] ?? stats);
            _footController.text = userData['preferred_foot'] == true ? '1' : '0';

            print(_nameController.text);
            print(_phoneController.text);
            print(_addressController.text);
            print(_dateController.text);
            print(_genderController.text);
            print(_cityController.text);
            print(_districtController.text);
            print(_weightController.text);
            print(_heightController.text);
            print(_footController.text);
          });
        }
      }
      return userDoc;
    } else {
      throw Exception('User not logged in');
    }
  }

  void _done() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      print(stats);
      //print(statConditioner.text);
      bool isRightPicked = _footController.text == '1';

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
          'height': _weightController.text,
          'weight': _heightController.text,
          'stats': stats,
          'preferred_foot': isRightPicked,
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
                              });
                              state.didChange(controller.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // Remove background color
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
                              controller.text.isNotEmpty
                                  ? controller.text
                                  : getHint(type),
                              style: TextStyle(
                                color: controller.text.isEmpty
                                    ? Colors.grey
                                    : Colors.white,
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
              if (value != null && value.isNotEmpty) {
                controller.text = value;
              }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  TextFormField(
                    key: _fieldKey,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: controller.text.isEmpty
                          ? getHint(type)
                          : controller.text,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
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
                      errorStyle: const TextStyle(
                          height: 0), // Hide the default error message
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
                  Positioned(
                    bottom: -20,
                    left: 0,
                    child: Builder(
                      builder: (context) {
                        final formFieldState = _fieldKey.currentState;
                        return Text(
                          formFieldState?.errorText ?? '',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
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
            initialValue: controller.text.isNotEmpty ? controller.text : null,
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
                    textController: controller,
                    onSaved: (value) {
                      state.didChange(value);
                      controller.text = value ?? '';
                    },
                    horizontalPadding: 5.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 197, 197),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text('Basic Information',
                    style: TextStyle(color: Colors.white, fontSize: 27)),
                const SizedBox(height: 27),
                _buildSection('Name', _nameController),
                const SizedBox(height: 16),
                _buildSection('Phone Number', _phoneController),
                const SizedBox(height: 16),
                _buildDropdownSection('Gender', _genderController),
                const SizedBox(height: 16),
                _buildDobSection('Date Of Birth', _dateController),
                const SizedBox(height: 16),
                //_buildDropdownSection('City/Province', _cityController),
                CityDropdown(
                        selectedCity: _selectedCity,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value ?? '';
                            _selectedDistrict = '';
                            _cityController.text = value ?? '';
                          });                         
                        },
                        //controller: _cityController,
                        citiesNameAndId: citiesNameAndId,
                      ),
                const SizedBox(height: 16),
                //_buildDropdownSection('District', _districtController),
                DistrictDropdown(
                        selectedCity: _selectedCity,
                        selectedDistrict: _selectedDistrict,
                        onChanged: (value) {
                          setState(() {
                            _selectedDistrict = value ?? '';
                            _districtController.text = value ?? '';
                          });
                        }, citiesNameAndId: citiesNameAndId,
                        
                ),
                const SizedBox(height: 16),
                _buildSection('Address', _addressController),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSection('Height', _heightController),
                    const SizedBox(width: 15),
                    _buildSection('Weight', _weightController),
                  ],
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                children: [
                  const Text(
                    'Preferred Foot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  //const SizedBox(width: 10),
                  FootPicker(controller: _footController),
                ]),
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

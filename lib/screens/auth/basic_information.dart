import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium_owner_home_screen.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:sportifind/widgets/date_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';

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

  late double latitude;
  late double longitude;
  final LocationService locService = LocationService();

  DateTime? selectedDate;
  DateTime? dob;

  Timer? _delayCityTime;
  Timer? _delayDistrictTime;
  final Map<String, String> citiesNameAndId = {};

  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredAddress = '';

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _delayCityTime?.cancel();
    _delayCityTime = Timer(const Duration(seconds: 2), () {
      setState(() {
        _cityController.text = '';
      });
    });
    _delayDistrictTime?.cancel();
    _delayDistrictTime =
        Timer(const Duration(seconds: 5, milliseconds: 300), () {
      setState(() {
        _districtController.text = '';
      });
    });
  }

  UploadTask? uploadTask;

  void _done() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        final ByteData byteData =
            await rootBundle.load('lib/assets/no_avatar.png');
        final Uint8List bytes = byteData.buffer.asUint8List();

        final userId = FirebaseAuth.instance.currentUser!.uid;
        LocationInfo? locationInfo = await locService.findLatAndLng(
            _districtController.text, _cityController.text);
        latitude = locationInfo!.latitude;
        longitude = locationInfo.longitude;

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(userId)
            .child('avatar')
            .child('avatar.jpg');

        final uploadTask = storageRef.putData(bytes);
        await uploadTask;

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': _enteredName,
          'phone': _enteredPhone,
          'dob': _dateController.text,
          'address': _enteredAddress,
          'gender': _genderController.text,
          'city': _cityController.text,
          'district': _districtController.text,
          'avatarImage': imageUrl,
          'latitude': latitude,
          'longitude': longitude,
        });

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (snapshot['role'] == 'player') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PlayerHomeScreen()));
        } else if (snapshot['role'] == 'stadium_owner') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StadiumOwnerHomeScreen()));
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
            style: SportifindTheme.normalTextBlack,
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
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            side: const BorderSide(
                              color: Colors.black,
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
                              style: GoogleFonts.lexend(
                                color: controller.text.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 14,
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
                        style: SportifindTheme.warningText,
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

    GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: SportifindTheme.normalTextBlack,
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
                return 'Please enter a value';
              }
              if (type == "Height" || type == "Weight") {
                if (double.tryParse(controller.text) == null) {
                  return 'Please enter a valid number';
                }
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller,
                    style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: controller.text.isEmpty
                          ? getHint(type)
                          : controller.text,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      // Remove the default errorStyle
                      errorStyle: const TextStyle(height: 0),
                    ),
                    onChanged: (value) {
                      state.didChange(value);
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        state.errorText ?? '',
                        style: SportifindTheme.warningText,
                      ),
                    ),
                ],
              );
            },
            onSaved: (value) {
              switch (type) {
                case 'Name':
                  _enteredName = controller.text;
                  break;
                case 'Phone Number':
                  _enteredPhone = controller.text;
                  break;
                case 'Address':
                  _enteredAddress = controller.text;
                  break;
              }
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
            style: SportifindTheme.normalTextBlack,
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
              if (controller.text.isEmpty) {
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
                        style: SportifindTheme.warningText,
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
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _done();
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor:
              WidgetStateProperty.all<Color>(SportifindTheme.bluePurple),
          shadowColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 213, 211, 211),
          ),
        ),
        child: Text(
          'Next',
          style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          //padding: const EdgeInsets.symmetric(horizontal: 120.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text('Basic Information',
                    style: SportifindTheme.sportifindFeatureAppBarBluePurple),
                const SizedBox(height: 27),
                _buildSection('Name', _nameController),
                const SizedBox(height: 16),
                _buildSection('Phone Number', _phoneController),
                const SizedBox(height: 16),
                _buildDropdownSection('Gender', _genderController),
                const SizedBox(height: 16),
                _buildDobSection('Date Of Birth', _dateController),
                const SizedBox(height: 16),
                SizedBox(
                  width: 290,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
                          children: const <TextSpan>[
                            TextSpan(text: 'City'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      CityDropdown(
                        selectedCity: _cityController.text,
                        onChanged: (value) {
                          setState(() {
                            _cityController.text = value ?? '';
                            _districtController.text = '';
                          });
                        },
                        citiesNameAndId: citiesNameAndId,
                        fillColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
                        children: const <TextSpan>[
                          TextSpan(text: 'District'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 290,
                      child: DistrictDropdown(
                        selectedCity: _cityController.text,
                        selectedDistrict: _districtController.text,
                        onChanged: (value) {
                          setState(() {
                            _districtController.text = value ?? '';
                          });
                        },
                        citiesNameAndId: citiesNameAndId,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection('Address', _addressController),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 192),
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

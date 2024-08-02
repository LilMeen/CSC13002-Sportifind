// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';
import 'package:sportifind/features/auth/presentations/widgets/dropdown_button.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/update_player.dart';
import 'package:sportifind/features/profile/presentation/widgets/foot_picker.dart';
import 'package:sportifind/features/profile/presentation/widgets/number_wheel.dart';
import 'package:sportifind/home/player_home_screen.dart';

final _formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class EditInformationScreen extends StatefulWidget {
  PlayerEntity player;

  EditInformationScreen({required this.player, super.key});

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

  Map<String, int> stats = {
    'PACE': 0,
    'DEF': 0,
    'SHOOTING': 0,
    'PASS': 0,
    'DRIVE': 0,
    'PHYSIC': 0,
  };

  Timer? _delayCityTime;
  Timer? _delayDistrictTime;

  final Map<String, String> citiesNameAndId = {};

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _footController.dispose();
    _delayCityTime?.cancel();
    _delayDistrictTime?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _nameController.text = widget.player.name;
      _phoneController.text = widget.player.phone;
      _addressController.text = widget.player.location.address;
      _dateController.text = widget.player.dob;
      _genderController.text = widget.player.gender;

      _delayCityTime?.cancel();
      _delayCityTime = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cityController.text = widget.player.location.city;
        });
      });
      _delayDistrictTime?.cancel();
      _delayDistrictTime = Timer(const Duration(milliseconds: 900), () {
        setState(() {
          _districtController.text = widget.player.location.district;
        });
      });

      _weightController.text = widget.player.weight;
      _heightController.text = widget.player.height;
      _footController.text = widget.player.preferredFoot;

      stats['DEF'] = widget.player.stats.def;
      stats['DRIVE'] = widget.player.stats.drive;
      stats['PACE'] = widget.player.stats.pace;
      stats['PASS'] = widget.player.stats.pass;
      stats['PHYSIC'] = widget.player.stats.physic;
      stats['SHOOTING'] = widget.player.stats.shoot;
    });
  }

  Future<void> _done() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      Location newLocation = await findLatAndLngFull(
        _addressController.text,
        _districtController.text,
        _cityController.text,
      );

      widget.player.name = _nameController.text;
      widget.player.phone = _phoneController.text;
      widget.player.dob = _dateController.text;
      widget.player.location = newLocation;
      widget.player.gender = _genderController.text;
      widget.player.weight = _weightController.text;
      widget.player.height = _heightController.text;
      widget.player.preferredFoot = _footController.text;
      widget.player.stats.def = stats['DEF']!;
      widget.player.stats.drive = stats['DRIVE']!;
      widget.player.stats.pace = stats['PACE']!;
      widget.player.stats.pass = stats['PASS']!;
      widget.player.stats.physic = stats['PHYSIC']!;
      widget.player.stats.shoot = stats['SHOOTING']!;

      try {
        await UseCaseProvider.getUseCase<UpdatePlayer>()
            .call(UpdatePlayerParams(player: widget.player));
        Navigator.of(context).pushReplacement(
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

    GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

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
            key: fieldKey,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type, style: SportifindTheme.normalTextBlack),
        const SizedBox(height: 12),
        SizedBox(
          width: 290,
          child: TextFormField(
            controller: controller,
            style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
            decoration: InputDecoration(
              hintText: getHint(type),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
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
            onSaved: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection(String type, TextEditingController controller) {
    double width = 290; // Default width
    GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

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
            key: fieldKey,
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
            style: SportifindTheme.normalTextBlack.copyWith(fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 137,
          height: 40,
          child: NumberWheel(
            onSaved: (value) => _handleSaved(type, value),
            initValue: stats[type] ?? 80,
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
            SportifindTheme.bluePurple,
          ),
        ),
        child: Text(
          'Next',
          style: SportifindTheme.normalTextWhite.copyWith(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double padding = (MediaQuery.of(context).size.width - 290 - 16 * 2) / 2;
    return Scaffold(
      appBar: const FeatureAppBarBluePurple(title: "Edit information"),
      backgroundColor: SportifindTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
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
                          style: SportifindTheme.normalTextBlack,
                          children: const <TextSpan>[
                            TextSpan(text: 'City'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      CityDropdown(
                        selectedCity: _cityController.text,
                        type: 'custom form',
                        onChanged: (value) {
                          setState(() {
                            _cityController.text = value ?? '';
                            _districtController.text = '';
                          });
                        },
                        citiesNameAndId: citiesNameAndId,
                        fillColor: Colors.white,
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
                        style: SportifindTheme.normalTextBlack,
                        children: const <TextSpan>[
                          TextSpan(text: 'District'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 290,
                      child: DistrictDropdown(
                        type: 'custom form',
                        selectedCity: _cityController.text,
                        selectedDistrict: _districtController.text,
                        onChanged: (value) {
                          setState(() {
                            _districtController.text = value ?? '';
                          });
                        },
                        citiesNameAndId: citiesNameAndId,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection('Address', _addressController),
                const SizedBox(height: 16),
                _buildSection('Height', _heightController),
                const SizedBox(height: 16),
                _buildSection('Weight', _weightController),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: padding),
                      child: Text('Preferred Foot',
                          style: SportifindTheme.normalTextBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: padding),
                      child: FootPicker(controller: _footController),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 190),
                  child: _nextButton(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_main_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/widgets/form/custom_form.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/image_service.dart';
import 'package:sportifind/widgets/app_bar/feature_app_bar_blue_purple.dart';
import 'package:sportifind/widgets/button/blue_purple_white_icon_loading_button.dart';
import 'package:sportifind/widgets/button/blue_purple_white_loading_buttton.dart';

class CreateTeamForm extends StatefulWidget {
  const CreateTeamForm({super.key});

  @override
  State<CreateTeamForm> createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'teamName': TextEditingController(),
    'district': TextEditingController(),
    'city': TextEditingController(),
  };

  final Map<String, String> _citiesNameAndId = {};
  String _selectedCity = '';
  String _selectedDistrict = '';

  LocationInfo? _location;
  Timer? _districtDelayTimer;

  late File _avatar;
  final List<File> _images = [];

  bool _isLoading = true;
  String _errorMessage = '';

  final CustomForm teamForm = CustomForm();
  final TeamService teamService = TeamService();
  final ImageService imgService = ImageService();

  Future<void> _prepareDefaultAvatar() async {
    try {
      final avatar = await imgService.getImageFileFromAssets(
          'lib/assets/avatar/default_stadium_avatar.jpg');
      setState(() {
        _avatar = avatar;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load data: $error';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareDefaultAvatar();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _districtDelayTimer?.cancel();
    super.dispose();
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await teamService.teamProcessing(
        action: 'create',
        controllers: _controllers,
        location: _location,
        selectedCity: _selectedCity,
        selectedDistrict: _selectedDistrict,
        avatar: _avatar,
        images: _images,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TeamMainScreen(),
          ),
        );
      }
    }
  }

  Future<void> _pickImageForAvatar(bool fromCamera) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    setState(() {
      if (pickedFile != null) {
        _avatar = pickedFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Scaffold(
      appBar: const FeatureAppBarBluePurple(title: 'Create team'),
      backgroundColor: SportifindTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              teamForm.buildTextFormField(
                controller: _controllers['teamName']!,
                label: 'Name',
                hint: 'Enter your team\'s name',
                validatorText: 'Please enter the team name',
              ),
              teamForm.buildCityDropdown(
                selectedCity: _selectedCity,
                citiesNameAndId: _citiesNameAndId,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value ?? '';
                    _selectedDistrict = '';
                  });
                },
              ),
              teamForm.buildDistrictDropdown(
                selectedCity: _selectedCity,
                selectedDistrict: _selectedDistrict,
                citiesNameAndId: _citiesNameAndId,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 8.0),
              teamForm.buildAvatarSection(
                buttonText: 'Add avatar image',
                avatar: _avatar,
                onPressed: () => imgService.showImagePickerOptions(
                    context, _pickImageForAvatar),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BluePurpleWhiteLoadingButton(
                  text: 'Create',
                  onPressed: _createTeam,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

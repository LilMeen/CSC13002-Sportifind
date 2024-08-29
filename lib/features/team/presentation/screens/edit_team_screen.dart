import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_loading_buttton.dart';
import 'package:sportifind/core/widgets/form/custom_form.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/bloc/team_bloc.dart';
import 'package:sportifind/features/team/presentation/screens/team_main_screen.dart';

class EditTeamScreen extends StatefulWidget {
  const EditTeamScreen({super.key, required this.team});
  final TeamEntity? team;

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final TeamBloc _bloc = TeamBloc();

  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'teamName': TextEditingController(),
    'district': TextEditingController(),
    'city': TextEditingController(),
  };

  final Map<String, String> _citiesNameAndId = {};
  String _selectedCity = '';
  String _selectedDistrict = '';

  Location? _location;
  Timer? _cityDelayTimer;
  Timer? _districtDelayTimer;

  late File _avatar;
  List<File> _images = [];

  bool _isLoading = true;
  List<PlayerEntity> teamMembers = [];
  final CustomForm teamForm = CustomForm();
  final ImageService imgService = ImageService();

  void prepareData() async {
    _controllers['teamName']!.text = widget.team!.name;
    _location = widget.team!.location;

    //_avatar = widget.team!.avatar;
    //_images = widget.team!.images ?? [];
    _avatar = await _bloc.downloadAvatarFile(widget.team!.id);
    if (widget.team!.images != null) {
      _images = await _bloc.downloadImageFiles(
          widget.team!.id, widget.team!.images!.length);
    }

    setState(() {
      _isLoading = false;
    });

    _cityDelayTimer?.cancel();
    _cityDelayTimer = Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _selectedCity = widget.team!.location.city;
      });
    });

    _districtDelayTimer?.cancel();
    _districtDelayTimer =
        Timer(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        _selectedDistrict = widget.team!.location.district;
      });
    });

    teamMembers = widget.team!.players;
  }

  @override
  void initState() {
    super.initState();
    prepareData();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _cityDelayTimer?.cancel();
    _districtDelayTimer?.cancel();
    super.dispose();
  }

  Future<void> _editTeam() async {
    if (!_formKey.currentState!.validate()) return;
    _location =
        _location!.copyWith(city: _selectedCity, district: _selectedDistrict);
    try {
      await _bloc.teamProcessing(
        action: 'edit',
        controllers: _controllers,
        location: _location,
        selectedCity: _selectedCity,
        selectedDistrict: _selectedDistrict,
        avatar: _avatar,
        images: _images,
        teamInformation: widget.team,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const TeamMainScreen(),
        ));
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

  Future<void> _addImageInList(bool fromCamera) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    setState(() {
      if (pickedFile != null) {
        _images.add(pickedFile);
      }
    });
  }

  Future<void> _replaceImageInList(bool fromCamera, int index) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    setState(() {
      if (pickedFile != null) {
        _images[index] = pickedFile;
      }
    });
  }

  void _deleteImageInList(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: const FeatureAppBarBluePurple(title: 'Edit team'),
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
                buttonText: 'Change avatar',
                avatar: _avatar,
                onPressed: () => imgService.showImagePickerOptions(
                    context, _pickImageForAvatar),
              ),
              teamForm.buildImageList(
                label: 'Other images',
                images: _images,
                addImage: () =>
                    imgService.showImagePickerOptions(context, _addImageInList),
                replaceImage: _replaceImageInList,
                deleteImage: _deleteImageInList,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BluePurpleWhiteLoadingButton(
                  text: 'Update',
                  onPressed: _editTeam,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

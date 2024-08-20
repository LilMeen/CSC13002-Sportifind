import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/widgets/form/custom_form.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/image_service.dart';
import 'package:sportifind/widgets/app_bar/feature_app_bar_blue_purple.dart';
import 'package:sportifind/widgets/button/blue_purple_white_icon_loading_button.dart';
import 'package:sportifind/widgets/button/blue_purple_white_loading_buttton.dart';

class EditStadiumScreen extends StatefulWidget {
  final StadiumData stadium;

  const EditStadiumScreen({super.key, required this.stadium});

  @override
  State<EditStadiumScreen> createState() => _EditStadiumScreenState();
}

class _EditStadiumScreenState extends State<EditStadiumScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'stadiumName': TextEditingController(),
    'stadiumAddress': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'openTime': TextEditingController(),
    'closeTime': TextEditingController(),
    'pricePerHour5': TextEditingController(),
    'pricePerHour7': TextEditingController(),
    'pricePerHour11': TextEditingController(),
  };

  final Map<String, String> _citiesNameAndId = {};
  String _selectedCity = '';
  String _selectedDistrict = '';

  int _num5PlayerFields = 0;
  int _num7PlayerFields = 0;
  int _num11PlayerFields = 0;
  bool availableField = false;

  LocationInfo? _location;
  Timer? _cityDelayTimer;
  Timer? _districtDelayTimer;

  late File _avatar;
  List<File> _images = [];

  bool _isLoading = true;

  final CustomForm stadiumForm = CustomForm();
  final StadiumService stadService = StadiumService();
  final LocationService locService = LocationService();
  final ImageService imgService = ImageService();

  void prepareData() async {
    _controllers['stadiumName']!.text = widget.stadium.name;
    _controllers['stadiumAddress']!.text = widget.stadium.location.address;
    _controllers['phoneNumber']!.text = widget.stadium.phone;
    _controllers['openTime']!.text = widget.stadium.openTime;
    _controllers['closeTime']!.text = widget.stadium.closeTime;

    double price5 = widget.stadium.getPriceOfTypeField('5-Player');
    double price7 = widget.stadium.getPriceOfTypeField('7-Player');
    double price11 = widget.stadium.getPriceOfTypeField('11-Player');
    _controllers['pricePerHour5']!.text =
        price5.toStringAsFixed(price5 == price5.toInt() ? 0 : 2);
    _controllers['pricePerHour7']!.text =
        price7.toStringAsFixed(price7 == price7.toInt() ? 0 : 2);
    _controllers['pricePerHour11']!.text =
        price11.toStringAsFixed(price11 == price11.toInt() ? 0 : 2);

    _num5PlayerFields = widget.stadium.getNumberOfTypeField('5-Player');
    _num7PlayerFields = widget.stadium.getNumberOfTypeField('7-Player');
    _num11PlayerFields = widget.stadium.getNumberOfTypeField('11-Player');

    _location = widget.stadium.location;

    _avatar = await stadService.downloadAvatarFile(widget.stadium.id);
    _images = await stadService.downloadImageFiles(
        widget.stadium.id, widget.stadium.images.length);

    setState(() {
      _isLoading = false;
    });

    _cityDelayTimer?.cancel();
    _cityDelayTimer = Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _selectedCity = widget.stadium.location.city;
      });
    });

    _districtDelayTimer?.cancel();
    _districtDelayTimer =
        Timer(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        _selectedDistrict = widget.stadium.location.district;
      });
    });
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

  Future<void> _editStadium() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await stadService.stadiumProcessing(
        action: 'edit',
        stadium: widget.stadium,
        controllers: _controllers,
        location: _location,
        selectedCity: _selectedCity,
        selectedDistrict: _selectedDistrict,
        num5PlayerFields: _num5PlayerFields,
        num7PlayerFields: _num7PlayerFields,
        num11PlayerFields: _num11PlayerFields,
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const OwnerStadiumScreen(),
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

  Future<void> _getCurrentLocation() async {
    try {
      LocationInfo? currentLoc = await locService.getCurrentLocation();
      if (currentLoc != null) {
        setState(() {
          _location = currentLoc;

          //////////for develop
          _location = LocationInfo(
            address: '227 D. Nguyen Van Cu, Phuong 4',
            district: '5',
            city: 'Ho Chi Minh',
            latitude: 10.7628356,
            longitude: 106.6824824,
          );
          ////////////////////

          _selectedCity = _location!.city;
          _controllers['stadiumAddress']!.text = _location!.address;
        });

        _districtDelayTimer?.cancel();
        _districtDelayTimer =
            Timer(const Duration(seconds: 1, milliseconds: 300), () {
          setState(() {
            _selectedDistrict = _location!.district;
          });
        });
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: const FeatureAppBarBluePurple(title: 'Edit stadium'),
      backgroundColor: SportifindTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              stadiumForm.buildTextFormField(
                controller: _controllers['stadiumName']!,
                label: 'Name',
                hint: 'Enter your stadium\'s name',
                validatorText: 'Please enter the stadium name',
              ),
              stadiumForm.buildCityDropdown(
                selectedCity: _selectedCity,
                citiesNameAndId: _citiesNameAndId,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value ?? '';
                    _selectedDistrict = '';
                  });
                },
              ),
              stadiumForm.buildDistrictDropdown(
                selectedCity: _selectedCity,
                selectedDistrict: _selectedDistrict,
                citiesNameAndId: _citiesNameAndId,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value ?? '';
                  });
                },
              ),
              stadiumForm.buildTextFormField(
                controller: _controllers['stadiumAddress']!,
                label: 'Address details',
                hint: 'Enter your stadium\'s address',
                validatorText: 'Please enter the address',
                spacingSection: 8.0,
              ),
              Center(
                child: Text('or', style: SportifindTheme.normalTextSmokeScreen),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: BluePurpleWhiteIconLoadingButton(
                  icon: Icons.place,
                  text: 'Set curent location as address',
                  onPressed: _getCurrentLocation,
                  type: 'round square',
                  size: 'small',
                ),
              ),
              const SizedBox(height: 16.0),
              stadiumForm.buildTextFormField(
                controller: _controllers['phoneNumber']!,
                label: 'Phone number',
                hint: 'Example: 0848182847',
                validatorText: 'Please enter the phone number',
                inputType: TextInputType.phone,
              ),
              stadiumForm.buildTimeFields(
                openTimeController: _controllers['openTime']!,
                closeTimeController: _controllers['closeTime']!,
                context: context,
                setState: () => setState(() {}),
              ),
              const SizedBox(height: 8.0),
              stadiumForm.buildAvatarSection(
                buttonText: 'Change avatar',
                avatar: _avatar,
                onPressed: () => imgService.showImagePickerOptions(
                    context, _pickImageForAvatar),
              ),
              stadiumForm.buildImageList(
                label: 'Other images',
                images: _images,
                addImage: () =>
                    imgService.showImagePickerOptions(context, _addImageInList),
                replaceImage: _replaceImageInList,
                deleteImage: _deleteImageInList,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Fields information',
                  style: SportifindTheme.sportifindFeatureAppBarBluePurpleSmall,
                ),
              ),
              const SizedBox(height: 12.0),
              stadiumForm.buildFieldRow(
                fieldType: '5-Player',
                fieldCount: _num5PlayerFields,
                priceController: _controllers['pricePerHour5']!,
                onIncrement: () => setState(() {
                  _num5PlayerFields++;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                onDecrement: () => setState(() {
                  if (_num5PlayerFields > 0) _num5PlayerFields--;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                availableField: availableField,
              ),
              stadiumForm.buildFieldRow(
                fieldType: '7-Player',
                fieldCount: _num7PlayerFields,
                priceController: _controllers['pricePerHour7']!,
                onIncrement: () => setState(() {
                  _num7PlayerFields++;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                onDecrement: () => setState(() {
                  if (_num7PlayerFields > 0) _num7PlayerFields--;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                availableField: availableField,
              ),
              stadiumForm.buildFieldRow(
                fieldType: '11-Player',
                fieldCount: _num11PlayerFields,
                priceController: _controllers['pricePerHour11']!,
                onIncrement: () => setState(() {
                  _num11PlayerFields++;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                onDecrement: () => setState(() {
                  if (_num11PlayerFields > 0) _num11PlayerFields--;
                  availableField = _num5PlayerFields > 0 ||
                      _num7PlayerFields > 0 ||
                      _num11PlayerFields > 0;
                }),
                availableField: availableField,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: BluePurpleWhiteLoadingButton(
                  text: 'Update',
                  onPressed: _editStadium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

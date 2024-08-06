import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/screens/stadium_owner/widget/stadium_form.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/image_service.dart';
import 'package:sportifind/widgets/location_button/current_location_button.dart';

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

  LocationInfo? _location;
  Timer? _cityDelayTimer;
  Timer? _districtDelayTimer;

  late File _avatar;
  List<File> _images = [];

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isLoadingLocation = false;

  final StadiumForm stadiumForm = StadiumForm();
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

    setState(() {
      _isSubmitting = true;
    });
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

      setState(() {
        _isSubmitting = false;
      });
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

  Widget _buildAvatarSection() {
    return stadiumForm.buildAvatarSection(
      _avatar,
      () => imgService.showImagePickerOptions(context, _pickImageForAvatar),
    );
  }

  Widget _buildImageList() {
    return stadiumForm.buildImageList(
      _avatar,
      _images,
      () => imgService.showImagePickerOptions(context, _addImageInList),
      _replaceImageInList,
      _deleteImageInList,
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

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
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Stadium')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 25),
              _buildImageList(),
              const SizedBox(height: 25),
              stadiumForm.buildTextFormField(
                _controllers['stadiumName']!,
                'Stadium name',
                'Please enter the stadium name',
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      stadiumForm.buildCityDropdown(
                        _selectedCity,
                        _citiesNameAndId,
                        (value) {
                          setState(() {
                            _selectedCity = value ?? '';
                            _selectedDistrict = '';
                          });
                        },
                      ),
                      stadiumForm.buildDistrictDropdown(
                        _selectedCity,
                        _selectedDistrict,
                        _citiesNameAndId,
                        (value) {
                          setState(() {
                            _selectedDistrict = value ?? '';
                          });
                        },
                      ),
                    ],
                  ),
                  CurrentLocationButton(
                    width: 56,
                    height: 56,
                    isLoading: _isLoadingLocation,
                    onPressed: _getCurrentLocation,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              stadiumForm.buildTextFormField(
                _controllers['stadiumAddress']!,
                'Address',
                'Please enter the address',
              ),
              const SizedBox(height: 10),
              stadiumForm.buildTextFormField(
                _controllers['phoneNumber']!,
                'Phone number',
                'Please enter the phone number',
                TextInputType.phone,
              ),
              const SizedBox(height: 10),
              stadiumForm.buildTimeFields(
                _controllers['openTime']!,
                _controllers['closeTime']!,
                context,
                () => setState(() {}),
              ),
              const SizedBox(height: 25),
              stadiumForm.buildFieldRow(
                '5-Player',
                _num5PlayerFields,
                _controllers['pricePerHour5']!,
                () => setState(() => _num5PlayerFields++),
                () => setState(() {
                  if (_num5PlayerFields > 0) _num5PlayerFields--;
                }),
              ),
              stadiumForm.buildFieldRow(
                '7-Player',
                _num7PlayerFields,
                _controllers['pricePerHour7']!,
                () => setState(() => _num7PlayerFields++),
                () => setState(() {
                  if (_num7PlayerFields > 0) _num7PlayerFields--;
                }),
              ),
              stadiumForm.buildFieldRow(
                '11-Player',
                _num11PlayerFields,
                _controllers['pricePerHour11']!,
                () => setState(() => _num11PlayerFields++),
                () => setState(() {
                  if (_num11PlayerFields > 0) _num11PlayerFields--;
                }),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _editStadium,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 40,
                          height: 30,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

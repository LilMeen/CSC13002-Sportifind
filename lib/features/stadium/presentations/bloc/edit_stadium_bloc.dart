// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/edit_stadium.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_form.dart';
import 'package:sportifind/home/stadium_owner_home_screen.dart';

class EditStadiumState {
  final bool isLoading;
  final bool isSubmitting;
  final bool isLoadingLocation;
  final String errorMessage;

  final String selectedCity;
  final String selectedDistrict;

  int num5PlayerFields;
  int num7PlayerFields;
  int num11PlayerFields;
  bool availableField;

  late File avatar;
  final List<File> images;
  Location location;

  EditStadiumState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.isLoadingLocation = false,
    this.errorMessage = '',

    this.selectedCity = '',
    this.selectedDistrict = '',

    this.num5PlayerFields = 0,
    this.num7PlayerFields = 0,
    this.num11PlayerFields = 0,
    this.availableField = false,

    required this.avatar,
    this.images = const [],
    this.location = const Location(),
  });

  EditStadiumState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isLoadingLocation,
    String? errorMessage,
    String? selectedCity,
    String? selectedDistrict,
    int? num5PlayerFields,
    int? num7PlayerFields,
    int? num11PlayerFields,
    bool? availableField,
    File? avatar,
    List<File>? images,
    Location? location,
  }) {
    return EditStadiumState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      num5PlayerFields: num5PlayerFields ?? this.num5PlayerFields,
      num7PlayerFields: num7PlayerFields ?? this.num7PlayerFields,
      num11PlayerFields: num11PlayerFields ?? this.num11PlayerFields,
      availableField: availableField ?? this.availableField,
      avatar: avatar ?? this.avatar,
      images: images ?? this.images,
      location: location ?? this.location,
    );
  }
}

class EditStadiumBloc {
  final StadiumEntity stadium;
  
  final BuildContext context;
  final _stateController = StreamController<EditStadiumState>.broadcast();
  late EditStadiumState _state;

  Stream<EditStadiumState> get stateStream => _stateController.stream;
  EditStadiumState get currentState => _state;

  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'stadiumName': TextEditingController(),
    'stadiumAddress': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'openTime': TextEditingController(),
    'closeTime': TextEditingController(),
    'pricePerHour5': TextEditingController(),
    'pricePerHour7': TextEditingController(),
    'pricePerHour11': TextEditingController(),
  };
  final Map<String, String> citiesNameAndId = {};


  Timer? _cityDelayTimer;
  Timer? _districtDelayTimer;

  final ImageService imgService = ImageService();

  EditStadiumBloc(this.context, this.stadium) : _state = EditStadiumState(avatar: stadium.avatar) {
    _stateController.add(_state);
  }

  void init()  {
    _prepareData();
  }

  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    _districtDelayTimer?.cancel();
    _stateController.close();
  }

  void _updateState(EditStadiumState Function(EditStadiumState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  Future<void> _prepareData() async {
    try {
      controllers['stadiumName']!.text = stadium.name;
      controllers['stadiumAddress']!.text = stadium.location.address;
      controllers['phoneNumber']!.text = stadium.phone;
      controllers['openTime']!.text = stadium.openTime;
      controllers['closeTime']!.text = stadium.closeTime;

      double price5 = stadium.getPriceOfTypeField('5-Player');
      double price7 = stadium.getPriceOfTypeField('7-Player');
      double price11 = stadium.getPriceOfTypeField('11-Player');
      controllers['pricePerHour5']!.text = price5.toStringAsFixed(price5 == price5.toInt() ? 0 : 2);
      controllers['pricePerHour7']!.text = price7.toStringAsFixed(price7 == price7.toInt() ? 0 : 2);
      controllers['pricePerHour11']!.text = price11.toStringAsFixed(price11 == price11.toInt() ? 0 : 2);

      final avatar = await _downloadAvatarFile(stadium.id);
      final images = await _downloadImageFiles(stadium.id, stadium.images.length);

      _updateState((state) => state.copyWith(
        num5PlayerFields: stadium.getNumberOfTypeField('5-Player'),
        num7PlayerFields: stadium.getNumberOfTypeField('7-Player'),
        num11PlayerFields: stadium.getNumberOfTypeField('11-Player'),
        availableField: true,
        location: stadium.location,
        avatar: avatar,
        images: images,
        isLoading: false,
      ));
    } catch (error) {
      _updateState((state) => state.copyWith(
        errorMessage: 'Failed to load data: $error',
        isLoading: false,
      ));
    }
  }

  Future<void> cityInit() async {
    _cityDelayTimer?.cancel();
    _cityDelayTimer = Timer(const Duration(milliseconds: 200), () {
      _updateState((state) => state.copyWith(selectedCity: stadium.location.city, selectedDistrict: ''));
    });
  }

  Future<void> districtInit() async {
    _districtDelayTimer?.cancel();
    _districtDelayTimer =
      Timer(const Duration(milliseconds: 200), () {
      _updateState((state) => state.copyWith(
        selectedCity: stadium.location.city, 
        selectedDistrict: stadium.location.district
      ));
    }); 
  }

  Future<void> editStadium() async {
    if (!formKey.currentState!.validate()) return;

    _updateState((state) => state.copyWith(isSubmitting: true));
    try {
      _state.location = await findLatAndLngFull(
        controllers['stadiumAddress']!.text,
        _state.selectedDistrict,
        _state.selectedCity,
      );
      await UseCaseProvider.getUseCase<EditStadium>().call(
        EditStadiumParams(
          stadium: stadium,
          id: stadium.id,
          name: controllers['stadiumName']!.text,
          location: _state.location,
          phoneNumber: controllers['phoneNumber']!.text,
          openTime: controllers['openTime']!.text,
          closeTime: controllers['closeTime']!.text,
          pricePerHour5: double.parse(controllers['pricePerHour5']!.text),
          pricePerHour7: double.parse(controllers['pricePerHour7']!.text),
          pricePerHour11: double.parse(controllers['pricePerHour11']!.text),
          num5PlayerFields: _state.num5PlayerFields,
          num7PlayerFields: _state.num7PlayerFields,
          num11PlayerFields: _state.num11PlayerFields,
          avatar: _state.avatar,
          images: _state.images,
        )
      );
      _updateState((state) => state.copyWith(isSubmitting: false));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StadiumOwnerHomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      _updateState((state) => state.copyWith(isSubmitting: false));
    }
  }

  Future<void> pickImageForAvatar(bool fromCamera) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    if (pickedFile != null) {
      _updateState((state) => state.copyWith(avatar: pickedFile));
    }
  }

  Future<void> addImageInList(bool fromCamera) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    if (pickedFile != null) {
      _updateState((state) => state.copyWith(
        images: [...state.images, pickedFile],
      ));
    }
  }

  Future<void> replaceImageInList(bool fromCamera, int index) async {
    final pickedFile = await imgService.pickImage(fromCamera);
    if (pickedFile != null) {
      final newImages = List<File>.from(_state.images);
      newImages[index] = pickedFile;
      _updateState((state) => state.copyWith(images: newImages));
    }
  }

  void deleteImageInList(int index) {
    final newImages = List<File>.from(_state.images);
    newImages.removeAt(index);
    _updateState((state) => state.copyWith(images: newImages));
  }

  Widget buildAvatarSection() {
    return StadiumForm().buildAvatarSection(
      _state.avatar,
      () => imgService.showImagePickerOptions(context, pickImageForAvatar),
    );
  }

  Widget buildImageList() {
    return StadiumForm().buildImageList(
      _state.avatar,
      _state.images,
      () => imgService.showImagePickerOptions(context, addImageInList),
      replaceImageInList,
      deleteImageInList,
    );
  }

  Future<void> getUserCurrentLocation() async {
    _updateState((state) => state.copyWith(isLoadingLocation: true));

    try {
      Location? currentLoc = await getCurrentLocation();
      if (currentLoc != null) {
        _updateState((state) => state.copyWith(
          location: currentLoc,
          selectedCity: currentLoc.city,   
        ));
        controllers['stadiumAddress']!.text = currentLoc.address;
        _districtDelayTimer?.cancel();
        _districtDelayTimer = Timer(const Duration(seconds: 1, milliseconds: 300), () {
          _updateState((state) => state.copyWith(selectedDistrict: currentLoc.district));
        });
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      _updateState((state) => state.copyWith(isLoadingLocation: false));
    }
  }

  void onCityChanged(String? value) {
    _updateState((state) => state.copyWith(
      selectedCity: value ?? '',
      selectedDistrict: '',
    ));
  }

  void onDistrictChanged(String? value) {
    _updateState((state) => state.copyWith(
      selectedDistrict: value ?? '',
    ));
  }

  Future<File> _downloadAvatarFile(String stadiumId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('stadiums')
        .child(stadiumId)
        .child('avatar')
        .child('avatar.jpg');

    try {
      final tempDir = await getTemporaryDirectory();
      final avatar = File('${tempDir.path}/avatar.jpg');

      await ref.writeToFile(avatar);

      return avatar;
    } catch (e) {
      throw Exception('Failed to download avatar file: $e');
    }
  }

  Future<List<File>> _downloadImageFiles(
      String stadiumId, int imageslength) async {
    List<File> files = [];

    for (int i = 0; i < imageslength; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('stadiums')
          .child(stadiumId)
          .child('images')
          .child('image_$i.jpg');

      try {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/image_$i.jpg');

        await ref.writeToFile(file);

        files.add(file);
      } catch (e) {
        throw Exception('Failed to download image files: $e');
      }
    }

    return files;
  }
}
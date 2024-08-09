// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/features/stadium/domain/usecases/create_stadium.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_form.dart';
import 'package:sportifind/home/stadium_owner_home_screen.dart';

class CreateStadiumState {
  final bool isLoading;
  final bool isSubmitting;
  final bool isLoadingLocation;
  final String errorMessage;

  final String selectedCity;
  final String selectedDistrict;
  int num5PlayerFields;
  int num7PlayerFields;
  int num11PlayerFields;
  late File avatar;
  final List<File> images;
  Location location;

  CreateStadiumState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.isLoadingLocation = false,
    this.errorMessage = '',

    this.selectedCity = '',
    this.selectedDistrict = '',
    this.num5PlayerFields = 0,
    this.num7PlayerFields = 0,
    this.num11PlayerFields = 0,
    required this.avatar,
    this.images = const [],
    this.location = const Location(),
  });

  CreateStadiumState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isLoadingLocation,
    String? errorMessage,

    String? selectedCity,
    String? selectedDistrict,
    int? num5PlayerFields,
    int? num7PlayerFields,
    int? num11PlayerFields,
    File? avatar,
    List<File>? images,
    Location? location,
  }) {
    return CreateStadiumState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      errorMessage: errorMessage ?? this.errorMessage,

      selectedCity: selectedCity ?? this.selectedCity,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      num5PlayerFields: num5PlayerFields ?? this.num5PlayerFields,
      num7PlayerFields: num7PlayerFields ?? this.num7PlayerFields,
      num11PlayerFields: num11PlayerFields ?? this.num11PlayerFields,
      avatar: avatar ?? this.avatar,
      images: images ?? this.images,
      location: location ?? this.location,
    );
  }
}




class CreateStadiumBloc {
  final BuildContext context;
  final _stateController = StreamController<CreateStadiumState>.broadcast();
  late CreateStadiumState _state;

  Stream<CreateStadiumState> get stateStream => _stateController.stream;
  CreateStadiumState get currentState => _state;

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
  Timer? _districtDelayTimer;
  final StadiumForm stadiumForm = StadiumForm();
  final ImageService imgService = ImageService();

  // Constructor
  //CreateStadiumBloc(this.context);
  CreateStadiumBloc(this.context) : _state = CreateStadiumState(avatar: File('')) {
    _stateController.add(_state);
  }

  void init() async {
    await _prepareDefaultAvatar();
  }

  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    _districtDelayTimer?.cancel();
    _stateController.close();
  }

  void _updateState(CreateStadiumState Function(CreateStadiumState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  Future<void> _prepareDefaultAvatar() async {
    try {
      final avatar = await imgService.getImageFileFromAssets(
          'lib/assets/avatar/default_stadium_avatar.jpg');
      _updateState((state) => state.copyWith(
            avatar: avatar,
            isLoading: false,
          ));
    } catch (error) {
      _updateState((state) => state.copyWith(
            errorMessage: 'Failed to load data: $error',
            isLoading: false,
          ));
    }
  }

  Future<void> creatingStadium() async {
    if (!formKey.currentState!.validate()) return;

    _updateState((state) => state.copyWith(isSubmitting: true));
    _state.location = (await findLatAndLngFull(
      controllers['stadiumAddress']!.text,
      _state.selectedDistrict,
      _state.selectedCity,
    ))!;
    try {
      await UseCaseProvider.getUseCase<CreateStadium>().call(
        CreateStadiumParams(
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
    return stadiumForm.buildAvatarSection(
      _state.avatar,
      () => imgService.showImagePickerOptions(context, pickImageForAvatar),
    );
  }

  Widget buildImageList() {
    return stadiumForm.buildImageList(
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

}
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_icon_loading_button.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_loading_buttton.dart';
import 'package:sportifind/core/widgets/form/custom_form.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/bloc/edit_stadium_bloc.dart';

class EditStadiumScreen extends StatefulWidget {
  final StadiumEntity stadium;

  const EditStadiumScreen({super.key, required this.stadium});

  @override
  State<EditStadiumScreen> createState() => _EditStadiumScreenState();
}

class _EditStadiumScreenState extends State<EditStadiumScreen> {
  late EditStadiumBloc _bloc;
  final CustomForm stadiumForm = CustomForm();
  final ImageService imgService = ImageService();

  @override
  void initState() {
    super.initState();
    _bloc = EditStadiumBloc(context, widget.stadium);
    _bloc.init();
  }

/*   @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditStadiumState>(
      stream: _bloc.stateStream,
      initialData: _bloc.currentState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final state = snapshot.data!;

        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Stadium')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _bloc.formKey,
              child: Column(
                children: [
                  _bloc.buildAvatarSection(),
                  const SizedBox(height: 25),
                  _bloc.buildImageList(),
                  const SizedBox(height: 25),
                  stadiumForm.buildTextFormField(
                    _bloc.controllers['stadiumName']!,
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
                            state.selectedCity,
                            _bloc.citiesNameAndId,
                            _bloc.onCityChanged,
                          ),
                          stadiumForm.buildDistrictDropdown(
                            state.selectedCity,
                            state.selectedDistrict,
                            _bloc.citiesNameAndId,
                            _bloc.onDistrictChanged,
                          ),
                        ],
                      ),
                      CurrentLocationButton(
                        width: 56,
                        height: 56,
                        isLoading: state.isLoadingLocation,
                        onPressed: _bloc.getUserCurrentLocation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  stadiumForm.buildTextFormField(
                    _bloc.controllers['stadiumAddress']!,
                    'Address',
                    'Please enter the address',
                  ),
                  const SizedBox(height: 10),
                  stadiumForm.buildTextFormField(
                    _bloc.controllers['phoneNumber']!,
                    'Phone number',
                    'Please enter the phone number',
                    TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  stadiumForm.buildTimeFields(
                    _bloc.controllers['openTime']!,
                    _bloc.controllers['closeTime']!,
                    context,
                    () => setState(() {}),
                  ),
                  const SizedBox(height: 25),
                  stadiumForm.buildFieldRow(
                    '5-Player',
                    state.num5PlayerFields,
                    _bloc.controllers['pricePerHour5']!,
                    () => setState(() => state.num5PlayerFields++),
                    () => setState(() {
                      if (state.num5PlayerFields > 0) state.num5PlayerFields--;
                    }),
                  ),
                  stadiumForm.buildFieldRow(
                    '7-Player',
                    state.num7PlayerFields,
                    _bloc.controllers['pricePerHour7']!,
                    () => setState(() => state.num7PlayerFields++),
                    () => setState(() {
                      if (state.num7PlayerFields > 0) state.num7PlayerFields--;
                    }),
                  ),
                  stadiumForm.buildFieldRow(
                    '11-Player',
                    state.num11PlayerFields,
                    _bloc.controllers['pricePerHour11']!,
                    () => setState(() => state.num11PlayerFields++),
                    () => setState(() {
                      if (state.num11PlayerFields > 0) state.num11PlayerFields--;
                    }),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting ? null : _bloc.editStadium,
                      child: state.isSubmitting
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
    );
  } */
    @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditStadiumState>(
      stream: _bloc.stateStream,
      initialData: _bloc.currentState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final state = snapshot.data!;

        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }

        return Scaffold(
          appBar: const FeatureAppBarBluePurple(title: 'Edit stadium'),
          backgroundColor: SportifindTheme.backgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _bloc.formKey,
              child: Column(
                children: [
                  stadiumForm.buildTextFormField(
                    controller: _bloc.controllers['stadiumName']!,
                    label: 'Name',
                    hint: 'Enter your stadium\'s name',
                    validatorText: 'Please enter the stadium name',
                  ),
                  stadiumForm.buildCityDropdown(
                    selectedCity: state.selectedCity,
                    citiesNameAndId: _bloc.citiesNameAndId,
                    onChanged: _bloc.onCityChanged,
                  ),
                  stadiumForm.buildDistrictDropdown(
                    selectedCity: state.selectedCity,
                    selectedDistrict: state.selectedDistrict,
                    citiesNameAndId: _bloc.citiesNameAndId,
                    onChanged: _bloc.onDistrictChanged,
                  ),
                  stadiumForm.buildTextFormField(
                    controller: _bloc.controllers['stadiumAddress']!,
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
                      onPressed: _bloc.getUserCurrentLocation,
                      type: 'round square',
                      size: 'small',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  stadiumForm.buildTextFormField(
                    controller: _bloc.controllers['phoneNumber']!,
                    label: 'Phone number',
                    hint: 'Example: 0848182847',
                    validatorText: 'Please enter the phone number',
                    inputType: TextInputType.phone,
                  ),
                  stadiumForm.buildTimeFields(
                    openTimeController: _bloc.controllers['openTime']!,
                    closeTimeController: _bloc.controllers['closeTime']!,
                    context: context,
                    setState: () => setState(() {}),
                  ),
                  const SizedBox(height: 8.0),
                  stadiumForm.buildAvatarSection(
                    buttonText: 'Change avatar',
                    avatar: state.avatar,
                    onPressed: () => imgService.showImagePickerOptions(
                        context, _bloc.pickImageForAvatar),
                  ),
                  stadiumForm.buildImageList(
                    label: 'Other images',
                    images: state.images,
                    addImage: () =>
                        imgService.showImagePickerOptions(context, _bloc.addImageInList),
                    replaceImage: _bloc.replaceImageInList,
                    deleteImage: _bloc.deleteImageInList,
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
                    fieldCount: state.num5PlayerFields,
                    priceController: _bloc.controllers['pricePerHour5']!,
                    onIncrement: () => setState(() {
                      state.num5PlayerFields++;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    onDecrement: () => setState(() {
                      if (state.num5PlayerFields > 0) state.num5PlayerFields--;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    availableField: state.availableField,
                  ),
                  stadiumForm.buildFieldRow(
                    fieldType: '7-Player',
                    fieldCount: state.num7PlayerFields,
                    priceController: _bloc.controllers['pricePerHour7']!,
                    onIncrement: () => setState(() {
                      state.num7PlayerFields++;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    onDecrement: () => setState(() {
                      if (state.num7PlayerFields > 0) state.num7PlayerFields--;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    availableField: state.availableField,
                  ),
                  stadiumForm.buildFieldRow(
                    fieldType: '11-Player',
                    fieldCount: state.num11PlayerFields,
                    priceController: _bloc.controllers['pricePerHour11']!,
                    onIncrement: () => setState(() {
                      state.num11PlayerFields++;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    onDecrement: () => setState(() {
                      if (state.num11PlayerFields > 0) state.num11PlayerFields--;
                      state.availableField = state.num5PlayerFields > 0 ||
                          state.num7PlayerFields > 0 ||
                          state.num11PlayerFields > 0;
                    }),
                    availableField: state.availableField,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: BluePurpleWhiteLoadingButton(
                      text: 'Update',
                      onPressed: _bloc.editStadium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sportifind/features/stadium/presentations/bloc/create_stadium_bloc.dart';
import 'package:sportifind/features/stadium/presentations/widgets/current_location_button.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_form.dart';

class CreateStadiumScreen extends StatefulWidget {
  static route() =>
    MaterialPageRoute(builder: (context) => const CreateStadiumScreen());

  const CreateStadiumScreen({super.key});

  @override
  State<CreateStadiumScreen> createState() => _CreateStadiumScreenState();
}

class _CreateStadiumScreenState extends State<CreateStadiumScreen> {
  late CreateStadiumBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CreateStadiumBloc(context);
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreateStadiumState>(
      stream: _bloc.stateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final state = snapshot.data!;

        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Upload Stadium')),
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
                  StadiumForm().buildTextFormField(
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
                          StadiumForm().buildCityDropdown(
                            state.selectedCity,
                            _bloc.citiesNameAndId,
                            _bloc.onCityChanged,
                          ),
                          StadiumForm().buildDistrictDropdown(
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
                  StadiumForm().buildTextFormField(
                    _bloc.controllers['stadiumAddress']!,
                    'Address',
                    'Please enter the address',
                  ),
                  const SizedBox(height: 10),
                  StadiumForm().buildTextFormField(
                    _bloc.controllers['phoneNumber']!,
                    'Phone number',
                    'Please enter the phone number',
                    TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  StadiumForm().buildTimeFields(
                    _bloc.controllers['openTime']!,
                    _bloc.controllers['closeTime']!,
                    context,
                    () => setState(() {}),
                  ),
                  const SizedBox(height: 25),
                  StadiumForm().buildFieldRow(
                    '5-Player',
                    state.num5PlayerFields,
                    _bloc.controllers['pricePerHour5']!,
                    () => setState(() => state.num5PlayerFields++),
                    () => setState(() {
                      if (state.num5PlayerFields > 0) state.num5PlayerFields--;
                    }),
                  ),
                  StadiumForm().buildFieldRow(
                    '7-Player',
                    state.num7PlayerFields,
                    _bloc.controllers['pricePerHour7']!,
                    () => setState(() => state.num7PlayerFields++),
                    () => setState(() {
                      if (state.num7PlayerFields > 0) state.num7PlayerFields--;
                    }),
                  ),
                  StadiumForm().buildFieldRow(
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
                      onPressed: state.isSubmitting ? null : _bloc.creatingStadium,
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
      },
    );
  }
}
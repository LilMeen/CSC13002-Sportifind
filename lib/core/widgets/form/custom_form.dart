import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_icon_normal_button.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';

class CustomForm {
  static const double spacingLabelBox = 6.0;
  static const double spacingSection = 16.0;

  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      hintStyle:
          SportifindTheme.textForm.copyWith(color: SportifindTheme.smokeScreen),
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
      errorStyle: SportifindTheme.errorForm,
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String validatorText,
    TextInputType inputType = TextInputType.text,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SportifindTheme.textForm),
        SizedBox(height: spacingLabelBox),
        TextFormField(
          controller: controller,
          style: SportifindTheme.textForm,
          decoration: customInputDecoration(hint),
          keyboardType: inputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            if (label == 'Phone number') {
              final phoneRegExp = RegExp(r'^[0-9+]?[0-9]{8,13}$');
              if (!phoneRegExp.hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
            }
            return null;
          },
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildCityDropdown({
    required String selectedCity,
    required Map<String, String> citiesNameAndId,
    required ValueChanged<String?> onChanged,
    Color fillColor = SportifindTheme.backgroundColor,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('City/Province', style: SportifindTheme.textForm),
        SizedBox(height: spacingLabelBox),
        SizedBox(
          width: double.infinity,
          child: CityDropdown(
            type: 'custom form',
            selectedCity: selectedCity,
            citiesNameAndId: citiesNameAndId,
            onChanged: onChanged,
            fillColor: fillColor,
          ),
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildDistrictDropdown({
    required String selectedCity,
    required String selectedDistrict,
    required Map<String, String> citiesNameAndId,
    required ValueChanged<String?> onChanged,
    Color fillColor = SportifindTheme.backgroundColor,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('District', style: SportifindTheme.textForm),
        SizedBox(height: spacingLabelBox),
        SizedBox(
          width: double.infinity,
          child: DistrictDropdown(
            type: 'custom form',
            selectedCity: selectedCity,
            selectedDistrict: selectedDistrict,
            citiesNameAndId: citiesNameAndId,
            onChanged: onChanged,
            fillColor: fillColor,
          ),
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildTimeFields({
    required TextEditingController openTimeController,
    required TextEditingController closeTimeController,
    required BuildContext context,
    required VoidCallback setState,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Open time', style: SportifindTheme.textForm),
                  SizedBox(height: spacingLabelBox),
                  TextFormField(
                    controller: openTimeController,
                    style: SportifindTheme.textForm,
                    decoration: customInputDecoration('07:00').copyWith(
                      suffixIcon: const Icon(Icons.expand_more, color: Colors.black),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 0),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && context.mounted) {
                        final now = DateTime.now();
                        final formattedTime = DateFormat('HH:mm').format(
                          DateTime(now.year, now.month, now.day, picked.hour,
                              picked.minute),
                        );
                        openTimeController.text = formattedTime;
                        setState();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the open time';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Close time', style: SportifindTheme.textForm),
                  SizedBox(height: spacingLabelBox),
                  TextFormField(
                    controller: closeTimeController,
                    style: SportifindTheme.textForm,
                    decoration: customInputDecoration('23:00').copyWith(
                      suffixIcon: const Icon(Icons.expand_more, color: Colors.black),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 23, minute: 0),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && context.mounted) {
                        final now = DateTime.now();
                        final formattedTime = DateFormat('HH:mm').format(
                          DateTime(now.year, now.month, now.day, picked.hour,
                              picked.minute),
                        );
                        closeTimeController.text = formattedTime;
                        setState();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the close time';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildAvatarSection({
    required String buttonText,
    required File avatar,
    required VoidCallback onPressed,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: BluePurpleWhiteIconNormalButton(
            icon: Icons.add_a_photo,
            text: buttonText,
            onPressed: onPressed,
            type: 'round square',
            size: 'small',
          ),
        ),
        SizedBox(height: spacingSection),
        AspectRatio(
          aspectRatio: 1.85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: avatar.path.contains('http')
            ?
            Image.network(
              avatar.path,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 250, color: Colors.grey),
            )
            :
            Image.file(
              avatar,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 250, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildImageList({
    required String label,
    required List<File> images,
    required VoidCallback addImage,
    required void Function(bool, int) replaceImage,
    required void Function(int) deleteImage,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SportifindTheme.largeLabelForm),
        SizedBox(height: spacingLabelBox),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              return index == images.length
                  ? buildAddImageButton(addImage)
                  : buildImage(
                      images[index], index, context, replaceImage, deleteImage);
            },
          ),
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }

  Widget buildImage(File image, int index, BuildContext context,
      void Function(bool, int) replaceImage, void Function(int) deleteImage) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 250,
                    child: image.path.contains('http')
                    ?
                    Image.network(
                      image.path,
                      fit: BoxFit.cover,
                    )
                    :
                    Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image.path.contains('http')
              ?
              Image.network(
                image.path,
                fit: BoxFit.cover,
                width: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              )
              :
              Image.file(
                image,
                fit: BoxFit.cover,
                width: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 18,
          child: PopupMenuButton(
            constraints: const BoxConstraints(
              maxWidth: 35,
            ),
            color: Colors.white,
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'replace',
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Icon(Icons.edit, size: 20),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Icon(Icons.delete, size: 20),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'replace') {
                ImageService().showImagePickerOptionsForReplace(
                    context, replaceImage, index);
              } else if (value == 'delete') {
                deleteImage(index);
              }
            },
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddImageButton(VoidCallback addImage) {
    return GestureDetector(
      onTap: addImage,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: SportifindTheme.whiteSmoke,
          border: Border.all(color: SportifindTheme.bluePurple),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: SportifindTheme.bluePurple),
            Text('Add image', style: SportifindTheme.smallTextBluePurple),
          ],
        ),
      ),
    );
  }

  Widget buildFieldRow({
    required String fieldType,
    required int fieldCount,
    required TextEditingController priceController,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required bool availableField,
    double spacingLabelBox = spacingLabelBox,
    double spacingSection = spacingSection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$fieldType Field:', style: SportifindTheme.largeLabelForm),
        SizedBox(height: spacingLabelBox),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: TextEditingController(text: fieldCount.toString()),
                style: SportifindTheme.textForm,
                readOnly: true,
                decoration: customInputDecoration('').copyWith(
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_drop_up, size: 24, color: Colors.black),
                          onPressed: onIncrement,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                          onPressed: onDecrement,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (fieldType == '5-Player' && !availableField) {
                    return 'Must have at least 1 field';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: priceController,
                style: SportifindTheme.textForm,
                decoration: customInputDecoration('Price').copyWith(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      '/VND',
                      style: SportifindTheme.textForm
                          .copyWith(color: SportifindTheme.smokeScreen),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (fieldCount > 0 && (value == null || value.isEmpty || value == '0')) {
                    return 'Please enter a price';
                  }

                  final numberRegExp = RegExp(r'^\d+(\.\d+)?$');
                  if (fieldCount > 0 &&
                      value != null &&
                      !numberRegExp.hasMatch(value)) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: spacingSection),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/image_service.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';

class StadiumForm {
  ImageService imgService = ImageService();

  Widget buildTextFormField(
      TextEditingController controller, String label, String validatorText,
      [TextInputType inputType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
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
    );
  }

  Widget buildTimeFields(
      TextEditingController openTimeController,
      TextEditingController closeTimeController,
      BuildContext context,
      VoidCallback setState) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: openTimeController,
            decoration: const InputDecoration(labelText: 'Open time'),
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
                openTimeController.text = picked.format(context);
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
        ),
        const SizedBox(width: 50),
        Expanded(
          child: TextFormField(
            controller: closeTimeController,
            decoration: const InputDecoration(labelText: 'Close time'),
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
                closeTimeController.text = picked.format(context);
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
        ),
      ],
    );
  }

  Widget buildFieldRow(
      String label,
      int fieldCount,
      TextEditingController priceController,
      VoidCallback onIncrement,
      VoidCallback onDecrement) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text('$label fields:')),
        SizedBox(
          width: 40,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  onPressed: onIncrement,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Center(child: Text('$fieldCount', textAlign: TextAlign.center)),
              Positioned(
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: onDecrement,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: priceController,
            decoration: const InputDecoration(
              suffixIcon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'VND',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'Please enter a price';
              }

              final numberRegExp = RegExp(r'^\d+(\.\d+)?$');
              if (fieldCount > 0 &&
                  !numberRegExp.hasMatch(value)) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildAvatarSection(File avatar, VoidCallback onPressed) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            avatar,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 250, color: Colors.grey),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              width: 110,
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                onPressed: onPressed,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Edit avatar', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageList(File avatar, List<File> images, VoidCallback addImage,
      void Function(bool, int) replaceImage, void Function(int) deleteImage) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 2,
        itemBuilder: (context, index) {
          if (index == images.length + 1) {
            return buildAddImageButton(addImage);
          } else {
            final imageFile = index == 0 ? avatar : images[index - 1];
            return buildImage(
                imageFile, index - 1, context, replaceImage, deleteImage);
          }
        },
      ),
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
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: 150,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              ),
            ),
          ),
        ),
        if (index > -1)
          Positioned(
            top: 0,
            right: 11,
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
                  imgService.showImagePickerOptionsForReplace(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: addImage,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: SportifindTheme.bluePurple3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate,
                  color: SportifindTheme.bluePurple3),
              Text('Add Image',
                  style: TextStyle(color: SportifindTheme.bluePurple3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCityDropdown(
    String selectedCity,
    Map<String, String> citiesNameAndId,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        const Text('City'),
        const SizedBox(width: 71.5),
        SizedBox(
          width: 150,
          child: CityDropdown(
            type: 'stadium form',
            selectedCity: selectedCity,
            citiesNameAndId: citiesNameAndId,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget buildDistrictDropdown(
    String selectedCity,
    String selectedDistrict,
    Map<String, String> citiesNameAndId,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        const Text('District'),
        const SizedBox(width: 50),
        SizedBox(
          width: 150,
          child: DistrictDropdown(
            type: 'stadium form',
            selectedCity: selectedCity,
            selectedDistrict: selectedDistrict,
            citiesNameAndId: citiesNameAndId,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
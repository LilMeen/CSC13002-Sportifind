import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

final _formKey = GlobalKey<FormState>();

class CreateTeamForm extends StatefulWidget {
  const CreateTeamForm({super.key});

  @override
  State<CreateTeamForm> createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var _enteredName = '';
  var _enteredAddress = '';

  Future<File> get getImageFileFromAssets async {
    final byteData = await rootBundle.load('lib/assets/logo/real_madrid.png');
    final tempDir = await getTemporaryDirectory();

    final tempFile = File('${tempDir.path}/your_image.jpg');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return tempFile;
  }

  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    if (pickedFile == null) {
      _image = await getImageFileFromAssets;
    }
  }

  void _submit() async {
    _image ?? await getImageFileFromAssets;

    final isValid = _formKey.currentState!.validate();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (isValid) {
      _formKey.currentState!.save();

      try {
        // add team data to teams collection in firestore
        DocumentReference docRef = firestore.collection('teams').doc();
        await docRef.set({
          'name': _enteredName,
          'foundedDate': Timestamp.now(),
          'address': _enteredAddress,
          'city': _cityController.text,
          'district': _districtController.text,
          'captain': userId,
          'members': [userId],
        });
        final teamId = docRef.id;
        // final constantImageUrl = FirebaseStorage.instance
        //     .ref()
        //     .child('dummy_images')
        //     .child('non_avatar_image')
        //     .child('8018698.jpg')
        //     .getDownloadURL();

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('teams')
            .child(teamId)
            .child('avatar')
            .child('avatar.jpg');

        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        firestore.collection('teams').doc(teamId).update({
          'avatarImage': imageUrl,
        });

        // add team to user's joinedTeams
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'joinedTeams': FieldValue.arrayUnion([teamId])
        });
      } catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to store data: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  String getHint(String type) {
    switch (type) {
      case 'Team Name':
        return 'Enter your team name';
      case 'Address':
        return 'Enter your Address';
      default:
        return 'Enter';
    }
  }

  bool isValidName(String input) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(input);
  }

  Widget _buildSection(String type, TextEditingController controller) {
    double width = 290; // Default width

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: width,
          height: 50,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: getHint(type),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 2, 183, 144),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
            onSaved: (value) {
              switch (type) {
                case 'Name':
                  _enteredName = value!;
                case 'Address':
                  _enteredAddress = value!;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection(String type, TextEditingController controller) {
    double width = 137; // Default width

    if (type == "District" || type == "City/Province") {
      width = 290;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <TextSpan>[
              TextSpan(text: type),
              const TextSpan(text: '*', style: TextStyle(color: Colors.red))
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: width,
          height: 50,
          child: Dropdown(
            type: type,
            onSaved: (value) {
              controller.text = value ?? '';
            },
            textController: controller,
          ),
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _submit();
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.tealAccent),
          shadowColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 213, 211, 211),
          ),
        ),
        child: const Text(
          'CREATE',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Team Information",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 27),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _buildSection('Name', _nameController),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: _buildSection('Address', _addressController),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _buildDropdownSection(
                          'City/Province', _cityController),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: _buildDropdownSection(
                          'District', _districtController),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: SportifindTheme.bluePurple3,
                            ),
                            SizedBox(width: 10),
                            Text('Add Image',
                                style: TextStyle(
                                    color: SportifindTheme.bluePurple3)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                  ),
                if (_image == null)
                  Image.asset(
                    'lib/assets/logo/real_madrid.png',
                    width: 100,
                    height: 100,
                  ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_submitButton(context)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

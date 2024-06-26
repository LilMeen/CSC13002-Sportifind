import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateStadium extends StatefulWidget {
  const CreateStadium({super.key});

  @override
  State<CreateStadium> createState() {
    return _CreateStadiumState();
  }
}

class _CreateStadiumState extends State<CreateStadium> {
  final TextEditingController _stadiumNameController = TextEditingController();
  final TextEditingController _stadiumCityController = TextEditingController();
  final TextEditingController _stadiumDistrictController = TextEditingController();
  final TextEditingController _stadiumAddressController = TextEditingController();
  final TextEditingController _numberOfFieldsController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();

  String selectedCity = '';
  Map<String, String> cityMap = {};
  var cityId = '';

  void _submit() async {
    FirebaseFirestore.instance
      .collection('stadiums')
      .add({
        'name': _stadiumNameController.text,
        'owner': FirebaseAuth.instance.currentUser!.uid,
        'city': _stadiumCityController.text,
        'district': _stadiumDistrictController.text,
        'address': _stadiumAddressController.text,
        'number_of_fields': int.parse(_numberOfFieldsController.text),
        'phone_number': _phoneNumberController.text,
        'open_time': _openTimeController.text,
        'close_time': _closeTimeController.text,
        'price_per_hour': double.parse(_pricePerHourController.text),
      });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload stadium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              controller: _stadiumNameController,
              decoration: const InputDecoration(
                labelText: 'Stadium name',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('City'),
                const SizedBox(width: 73),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                    .collection('location')
                    .orderBy('city', descending: false)
                    .snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem<String>> items = [];
                    if (!snapshot.hasData){
                      const CircularProgressIndicator();
                    }
                    else {
                      final cities = snapshot.data!.docs.toList();
                      final cityIds = snapshot.data!.docs.map((e) => e.id).toList();
                      cityMap = Map.fromIterables(cities.map((e) => e['city'].toString()), cityIds);
                      items.add(const DropdownMenuItem(value: '', child: Text('Select city')));
                      for (var city in cities) {
                        items.add(
                          DropdownMenuItem(
                            value: city['city'].toString(),
                            child: Text(city['city'].toString()),
                          ),
                        );
                      }
                    }
                    return DropdownButton(
                      items: items,
                      value: _stadiumCityController.text,
                      onChanged: (value) {
                        setState(() {
                          _stadiumCityController.text = value.toString();
                          _stadiumDistrictController.text = ''; 
                        });
                      },
                    );
                  }
                ),
              ],
            ),

            const SizedBox(width: 50),

            // District
            Row(
              children: [
                const Text('District'),
                const SizedBox(width: 50),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                    .collection('location/${cityMap[_stadiumCityController.text]}/district')
                    .orderBy('name', descending: false)
                    .snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem<String>> items = [];
                    if (!snapshot.hasData){
                      const CircularProgressIndicator();
                    }
                    else {
                      final districts = snapshot.data!.docs.toList();
                      items.add(const DropdownMenuItem(value: '', child: Text('Select district')));
                      for (var district in districts) {
                        items.add(
                          DropdownMenuItem(
                            value: district['name'].toString(),
                            child: Text(district['name'].toString()),
                          ),
                        );
                      }
                    }
                    return DropdownButton(
                      items: items,
                      value: _stadiumDistrictController.text,
                      onChanged: (value) {
                        setState(() {
                          _stadiumDistrictController.text = value.toString();
                        });
                      },
                    );
                  }
                ),
              ],
            ),


            TextFormField(
              controller: _stadiumAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
            TextFormField(
              controller: _numberOfFieldsController,
              decoration: const InputDecoration(
                labelText: 'Number of fields',
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _openTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Open time',
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 0),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _openTimeController.text = picked.toString().substring(10, 15);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: TextFormField(
                    controller: _closeTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Close time',
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 0),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _closeTimeController.text = picked.toString().substring(10, 15);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _pricePerHourController,
              decoration: const InputDecoration(
                labelText: 'Price per hour',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

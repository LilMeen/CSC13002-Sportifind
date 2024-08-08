import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/util/stadium_service.dart';

class UpdateStatusScreen extends StatefulWidget {
  final StadiumData stadium;

  const UpdateStatusScreen({super.key, required this.stadium});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  bool _isUpdating = false;
  final Map<String, String> _fieldsStatus = {};
  final StadiumService _stadiumService = StadiumService();

  @override
  void initState() {
    super.initState();
    // Initialize dropdown values with the current status of the fields
    for (var field in widget.stadium.fields) {
      _fieldsStatus[field.id] = field.status ? 'active' : 'maintaining';
    }
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await _stadiumService.updateFieldStatus(widget.stadium, _fieldsStatus);

      setState(() {
        _isUpdating = false;
      });

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const OwnerStadiumScreen(),
        ));
      }
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  List<Widget> _buildFieldDropdowns(String fieldType) {
    final fields = widget.stadium.fields
        .where((field) => field.type == fieldType)
        .toList()
      ..sort((a, b) => a.numberId.compareTo(b.numberId)); // Sort by numberId

    return fields.map((field) {
      return _buildDropdownRow(
        'Field ${field.numberId}',
        _fieldsStatus[field.id]!,
        (String? newValue) {
          setState(() {
            _fieldsStatus[field.id] = newValue!;
          });
        },
      );
    }).toList();
  }

  Widget _buildDropdownRow(
      String fieldName, String dropdownValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Text(
            fieldName,
            style: SportifindTheme.body,
          ),
          const Spacer(),
          Container(
            width: 160,
            height: 40,
            padding: const EdgeInsets.only(left: 12.0, right: 6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: onChanged,
                iconSize: 30,
                dropdownColor: Colors.white,
                items: <String>['active', 'maintaining']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: value == 'active'
                          ? (value == dropdownValue
                              ? SportifindTheme.dropdownGreenBold
                              : SportifindTheme.dropdownGreen)
                          : (value == dropdownValue
                              ? SportifindTheme.dropdownRedBold
                              : SportifindTheme.dropdownRed),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return <String>['active', 'maintaining'].map((String value) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: value == 'active'
                            ? SportifindTheme.dropdownGreen
                            : SportifindTheme.dropdownRed,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFieldSection(String fieldType, int fieldCount) {
    return fieldCount > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$fieldType Field', style: SportifindTheme.bodyTitle),
              const SizedBox(height: 8),
              ..._buildFieldDropdowns(fieldType),
              const SizedBox(height: 20),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final int num5 = widget.stadium.getNumberOfTypeField('5-Player');
    final int num7 = widget.stadium.getNumberOfTypeField('7-Player');
    final int num11 = widget.stadium.getNumberOfTypeField('11-Player');
    final bool noFields = num5 == 0 && num7 == 0 && num11 == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Status',
          style: SportifindTheme.AppBarTittle3,
        ),
        centerTitle: true,
        backgroundColor: SportifindTheme.background,
        iconTheme: const IconThemeData(color: SportifindTheme.bluePurple),
        elevation: 0,
        surfaceTintColor: SportifindTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: SportifindTheme.background,
      body: noFields
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Image.asset(
                  'lib/assets/no_data/no_data.png',
                  width: 250,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldSection('5-Player', num5),
                    _buildFieldSection('7-Player', num7),
                    _buildFieldSection('11-Player', num11),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _isUpdating ? null : _updateStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.white,
                          foregroundColor: SportifindTheme.bluePurple,
                        ),
                        child: _isUpdating
                            ? const SizedBox(
                                width: 40,
                                height: 30,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

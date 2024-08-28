import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_loading_buttton.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/update_field_status.dart';
import 'package:sportifind/home/stadium_owner_home_screen.dart';

class UpdateStatusScreen extends StatefulWidget {
  final StadiumEntity stadium;

  const UpdateStatusScreen({super.key, required this.stadium});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  final Map<String, String> _fieldsStatus = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.stadium.fields) {
      _fieldsStatus[field.id] = field.status ? 'active' : 'maintaining';
    }
  }

  Future<void> _updateStatus() async {
    try {
      for (var field in widget.stadium.fields) {
        field.copyWith(status: _fieldsStatus[field.id] == 'active');
      }
      for (var field in _fieldsStatus.entries) {
        print('${field.key}: ${field.value}');
      }
      await UseCaseProvider.getUseCase<UpdateFieldStatus>().call(
        UpdateFieldStatusParams(widget.stadium),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StadiumOwnerHomeScreen(),
        ));
      }
    } catch (e) {
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
          Text(
            fieldName,
            style: SportifindTheme.body,
          ),
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
                              ? SportifindTheme.boldStatusDropdown.copyWith(color: Colors.green)
                              : SportifindTheme.statusDropdown.copyWith(color: Colors.green))
                          : (value == dropdownValue
                              ? SportifindTheme.boldStatusDropdown.copyWith(color: Colors.red)
                              : SportifindTheme.statusDropdown.copyWith(color: Colors.red)),
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
                            ? SportifindTheme.statusDropdown.copyWith(color: Colors.green)
                            : SportifindTheme.statusDropdown.copyWith(color: Colors.red),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: _buildFieldDropdowns(fieldType),
                ),
              ),
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
      appBar: const FeatureAppBarBluePurple(title: 'Update status'),
      backgroundColor: SportifindTheme.backgroundColor,
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: BluePurpleWhiteLoadingButton(
                        text: 'Update status',
                        onPressed: _updateStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

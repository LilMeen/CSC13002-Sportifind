import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/match/screens/date_select_screen.dart';
import 'package:sportifind/screens/stadium_owner/widget/stadium_sliding_photos.dart';
import 'package:sportifind/screens/stadium_owner/stadium/edit_stadium_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium/update_status_screen.dart';
import 'package:sportifind/screens/stadium_owner/widget/stadium_info_app_bar.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/widgets/button/blue_purple_white_normal_buttton.dart';
import 'package:sportifind/widgets/delete_dialog/delete_dialog.dart';

class StadiumInfoScreen extends StatelessWidget {
  final StadiumData stadium;
  final String ownerName;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
  final void Function(MatchCard matchcard)? addMatchCard;

  const StadiumInfoScreen({
    super.key,
    required this.stadium,
    required this.ownerName,
    required this.isStadiumOwnerUser,
    required this.forMatchCreate,
    this.addMatchCard,
    required this.selectedTeamId,
    required this.selectedTeamName,
    required this.selectedTeamAvatar,
  });

  Widget _buildDetailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 237, 237, 237),
              child: Icon(icon, color: SportifindTheme.bluePurple, size: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: SportifindTheme.normalTextBlack,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailFieldRow(String type) {
    return stadium.getNumberOfTypeField(type) > 0
        ? Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                      child: Text(stadium.getNumberOfTypeField(type).toString(),
                          style: SportifindTheme.fieldNumberStadiumInfo),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$type field',
                        style: SportifindTheme.normalTextBlack,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 130,
                child: _buildDetailRow(Icons.attach_money,
                    stadium.formatPrice(stadium.getPriceOfTypeField(type))),
              ),
            ],
          )
        : const SizedBox();
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StadiumDeleteDialog(
          content: 'Do you want to delete this stadium?',
          onDelete: () {
            StadiumService().deleteStadium(stadium.id).then((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const OwnerStadiumScreen(),
                ),
              );
            }).catchError((error) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to delete stadium: $error"),
                ),
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StadiumInfoAppBar(
        isStadiumOwnerUser: isStadiumOwnerUser,
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStadiumScreen(stadium: stadium),
            ),
          );
        },
        onDelete: () {
          _showDeleteDialog(context);
        },
        onUpdateStatus: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateStatusScreen(stadium: stadium),
            ),
          );
        },
      ),
      backgroundColor: SportifindTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StadiumSlidingPhotos(stadium: stadium),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.person_outlined, ownerName),
                  _buildDetailRow(Icons.place_outlined,
                      '${stadium.location.address}, ${stadium.location.district}, ${stadium.location.city}'),
                  _buildDetailRow(Icons.phone_outlined, stadium.phone),
                  _buildDetailFieldRow('5-Player'),
                  _buildDetailFieldRow('7-Player'),
                  _buildDetailFieldRow('11-Player'),
                ],
              ),
              const SizedBox(height: 16),
              forMatchCreate == true
                  ? SizedBox(
                      width: double.infinity,
                      child: BluePurpleWhiteNormalButton(
                        text: 'Pick this stadium',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DateSelectScreen(
                                selectedTeamId: selectedTeamId!,
                                selectedTeamName: selectedTeamName!,
                                selectedTeamAvatar: selectedTeamAvatar!,
                                stadiumData: stadium,
                                addMatchCard: addMatchCard,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

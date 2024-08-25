import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_normal_buttton.dart';
import 'package:sportifind/features/match/presentation/screens/create_match/date_select_screen.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/bloc/stadium_info_bloc.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/edit_stadium_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/update_status_screen.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_delete_dialog.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_info_app_bar.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_sliding_photos.dart';

class StadiumInfoScreen extends StatefulWidget {
  final StadiumEntity stadium;
  final String ownerName;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final TeamEntity? selectedTeam;

  const StadiumInfoScreen({
    super.key,
    required this.stadium,
    required this.ownerName,
    required this.isStadiumOwnerUser,
    required this.forMatchCreate,
    required this.selectedTeam,
  });

  @override
  State<StadiumInfoScreen> createState() => _StadiumInfoScreenState();
}

class _StadiumInfoScreenState extends State<StadiumInfoScreen> {
  late StadiumInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = StadiumInfoBloc(context, widget.stadium);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

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
    return widget.stadium.getNumberOfTypeField(type) > 0
        ? Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                      child: Text(widget.stadium.getNumberOfTypeField(type).toString(),
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
                    _bloc.formatPrice(widget.stadium.getPriceOfTypeField(type))),
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
            Navigator.of(context).pop();
            _bloc.deleteStadium(); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StadiumInfoAppBar(
        isStadiumOwnerUser: widget.isStadiumOwnerUser,
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStadiumScreen(stadium: widget.stadium),
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
              builder: (context) => UpdateStatusScreen(stadium: widget.stadium),
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
              StadiumSlidingPhotos(stadium: widget.stadium),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.person_outlined, widget.ownerName),
                  _buildDetailRow(Icons.place_outlined,
                      '${widget.stadium.location.address}, ${widget.stadium.location.district}, ${widget.stadium.location.city}'),
                  _buildDetailRow(Icons.phone_outlined, widget.stadium.phone),
                  _buildDetailFieldRow('5-player'),
                  _buildDetailFieldRow('7-player'),
                  _buildDetailFieldRow('11-player'),
                ],
              ),
              const SizedBox(height: 16),
              widget.forMatchCreate == true
                  ? SizedBox(
                      width: double.infinity,
                      child: BluePurpleWhiteNormalButton(
                        text: 'Pick this stadium',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DateSelectScreen(
                                stadiumData: widget.stadium,
                                selectedTeam: widget.selectedTeam!,
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

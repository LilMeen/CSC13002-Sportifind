import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/match/presentation/screens/create_match/date_select_screen.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/edit_stadium_screen.dart';
import 'package:sportifind/features/stadium/presentations/bloc/stadium_info_bloc.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stadium Information'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<StadiumInfoState>(
        stream: _bloc.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _bloc.currentState;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      state.selectedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 250, color: Colors.grey);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.stadium.images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.stadium.images.length + 1,
                        itemBuilder: (context, index) {
                          String imageUrl = index == 0
                              ? widget.stadium.avatar.path
                              : widget.stadium.images[index - 1].path;
                          return _buildImage(imageUrl);
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Baseline(
                                    baseline: 23.5,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Icon(Icons.stadium,
                                        color: Colors.teal, size: 30),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.stadium.name,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                  Icons.person, 'Owner', widget.ownerName),
                              _buildDetailRow(Icons.location_on, 'Address',
                                  '${widget.stadium.location.address}, ${widget.stadium.location.district}, ${widget.stadium.location.city}'),
                              _buildDetailRow(Icons.access_time, 'Opening Time',
                                  '${widget.stadium.openTime} ~ ${widget.stadium.closeTime}'),
                              _buildDetailRow(
                                  Icons.phone, 'Phone', widget.stadium.phone),
                              if (widget.stadium.getNumberOfTypeField('5-Player') >
                                  0)
                                _buildDetailFieldRow('5-Player'),
                              if (widget.stadium.getNumberOfTypeField('7-Player') >
                                  0)
                                _buildDetailFieldRow('7-Player'),
                              if (widget.stadium.getNumberOfTypeField('11-Player') >
                                  0)
                                _buildDetailFieldRow('11-Player'),
                            ],
                          ),
                        ),
                      ),
                      widget.isStadiumOwnerUser
                          ? Positioned(
                              top: 10,
                              right: 15,
                              child: PopupMenuButton(
                                constraints: const BoxConstraints(
                                  maxWidth: 40,
                                ),
                                color: Colors.white,
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Icon(Icons.edit, size: 25),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      height: 30,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Icon(Icons.delete, size: 25),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditStadiumScreen(stadium: widget.stadium),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    _showDeleteDialog();
                                  }
                                },
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  widget.forMatchCreate == true
                      ? Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: SportifindTheme.grey,
                          ),
                          child: TextButton(
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
                        child: const Text(
                          "Pick this stadium",
                          style: SportifindTheme.status,
                        ),
                      ),
                    )
                  : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // PRIVATE METHODS
    Widget _buildImage(String imageUrl) {
    return GestureDetector(
      onTap: () => _bloc.onImageTap(imageUrl),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
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
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 26,
                baselineType: TextBaseline.alphabetic,
                child: Icon(icon, color: Colors.teal, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$label: ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
        ],
      ),
    );
  }

  Widget _buildDetailFieldRow(String type) {
    return _buildDetailRow(Icons.sports_soccer, '$type fields',
        '${widget.stadium.getNumberOfTypeField(type).toString()}  (${_bloc.formatPrice(widget.stadium.getPriceOfTypeField(type))} VND/h)');
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to delete this stadium? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            StreamBuilder<StadiumInfoState>(
              stream: _bloc.stateStream,
              builder: (context, snapshot) {
                final state = snapshot.data ?? _bloc.currentState;
                return TextButton(
                  onPressed: state.isDeleting ? null : () {
                    Navigator.of(context).pop();
                    _bloc.deleteStadium(); 
                  },
                  child: state.isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text("Delete"),
                );
              },
            ),
          ],
        );
      },
    );
  }
}